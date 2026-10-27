#!/usr/bin/env python3
"""Генерирует обои в стиле macOS Sonoma (волны) через ffmpeg geq."""
import subprocess, sys

W, H = 3840, 1200
OUT = sys.argv[1] if len(sys.argv) > 1 else "wallpaper.png"

def rgb(h): return [int(h[i:i+2], 16) for i in (1, 3, 5)]

bg_top, bg_bot = rgb("#0d1433"), rgb("#2a1d5e")
# (база по высоте, [(амплитуда, частота, фаза)], цвет сверху, цвет снизу)
layers = [
    (0.36, [(70, 1.3, 0.4), (35, 3.1, 2.0)], "#33287a", "#241a5a"),
    (0.50, [(85, 1.1, 2.2), (30, 2.7, 0.7)], "#5536a3", "#3a2780"),
    (0.64, [(80, 1.6, 4.1), (40, 2.2, 1.3)], "#9447ad", "#64368f"),
    (0.78, [(75, 1.2, 1.0), (30, 3.4, 3.3)], "#d9678f", "#a84a8e"),
    (0.91, [(55, 1.5, 5.2), (25, 2.9, 0.2)], "#f59f78", "#de767c"),
]

def channel(i):
    e = f"st(0,{bg_top[i]}+({bg_bot[i]-bg_top[i]})*Y/H)"
    for base, waves, top, bot in layers:
        t, b = rgb(top)[i], rgb(bot)[i]
        y = f"{base*H}" + "".join(f"+{a}*sin(X*{f}*2*PI/W+{p})" for a, f, p in waves)
        e += (
            f";st(1,{y})"
            f";st(2,Y-ld(1))"
            # тень над краем волны
            f";st(0,ld(0)*(1-0.35*exp(-abs(ld(2))/45)*lt(ld(2),0)))"
            # мягкий край (сглаживание)
            f";st(3,clip(ld(2)/2.5,0,1))"
            # цвет слоя: градиент + светлый блик у кромки
            f";st(4,{t}+({b-t})*clip(ld(2)/{0.3*H},0,1)+45*exp(-ld(2)/22)*gt(ld(2),0))"
            f";st(0,ld(0)*(1-ld(3))+ld(4)*ld(3))"
        )
    return e + ";clip(ld(0),0,255)"

vf = f"format=rgb24,geq=r='{channel(0)}':g='{channel(1)}':b='{channel(2)}'"
subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-f", "lavfi", "-i",
                f"color=black:size={W}x{H}", "-vf", vf, "-frames:v", "1", OUT], check=True)
print("saved", OUT)
