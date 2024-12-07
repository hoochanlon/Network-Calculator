# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['C:\\Users\\胡成龙\\Desktop\\Network-Calculator\\main.py'],
    pathex=[],
    binaries=[],
    datas=[('C:\\Users\\胡成龙\\Desktop\\Network-Calculator\\docs', 'docs'), ('C:\\Users\\胡成龙\\Desktop\\Network-Calculator\\images', 'images')],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='IP地址规划计算器v1.3.1',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['C:\\Users\\胡成龙\\Desktop\\Network-Calculator\\images\\logo.ico'],
)
