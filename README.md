# Building the FBX SDK for Python
FBX Python SDK は Python 3.3 用が提供されており、それ以外の Python バージョンで使用するには FBX Python Bindings をビルドすることになります。  
そのままではビルドすることが出来なかったので、修正箇所や手順の覚え書きを残しておきます。

## Python バージョン
* 3.8.3 (64bit)

## FBX バージョン
* 2020.1.1

## OS/CPU
* Windows 10 Pro 64bit
* i7-8500Y

## コンパイラ
* Microsoft Visual Studio 2019 Community

## 注意事項（重要）
* FBX Python Bindings の パスに半角スペースを含めない
    * パスに半角スペースがあるとビルドに失敗するのでインストール時にパスを変更するか、インストールしたフォルダを別の場所にコピーしてリネームする
    * FBX Python Bindings というフォルダ名がそもそもＮＧなので注意
* 対応する sip を使うこと
    * FBX Python Bindings の readme.txt に使用したバージョンが書いてある
    * 2020.1.1 は sip-4.19.3
    * これより新しいバージョンを使用すると以下のエラーが出る
        * size_t の定義 
        * override (C++11)
        * privateの代入演算子オーバーロード

## ビルド手順
1. sip-4.19.3 を解凍 (https://www.riverbankcomputing.com/hg/sip から入手)  
sip-4.19.3\configure.py を実行  
環境変数 SIP_ROOT にパスを登録  
2. FBX SDK 2020.1.1 をインストール  
環境変数 FBXSDK_ROOT にパスを登録  
3. FBX Python Bindings 2020.1.1 をインストール  
後述の修正を当てる  
FBX Python Bindings\2020.1.1\PythonBindings.pyを実行してビルド  
FBX Python Bindings\2020.1.1\build\Distrib\site-packages\fbx\* を site-packages へコピー

## FBX Python Bindings 2020.1.1 修正箇所
* CPUの判定を修正  
FBX Python Bindings\2020.1.1\configure.py (32)
    ```Python:configure.py
        if platform.machine() == 'x86_64':
    ```
    ↓
    ```Python:configure.py
        if platform.machine() == 'x86_64' or platform.machine() == 'AMD64':
    ```
* FBX SDK の lib のパスを修正  
FBX Python Bindings\2020.1.1\PythonBindings.py(22)
    ```Python:PythonBindings.py
    vsCompiler = "vs2015"
    ```
    ↓
    ```Python:PythonBindings.py
    vsCompiler = "vs2017"
    ```
* vcvars64.bat (Visual Studio) へのパスを修正  
FBX Python Bindings\2020.1.1\PythonBindings.py(202)
    ```Python:PythonBindings.py
    def vcvars(platform_tag):
        prefix = vcCompiler.replace('vc', 'VS')
        vc_common_tool_dir = os.path.expandvars('$'+prefix+'COMNTOOLS')
        if platform_tag == 'FBX_X64':
            result = os.path.normpath(os.path.join(vc_common_tool_dir, '../../VC/bin/amd64/vcvars64.bat'))
        else:
            result = os.path.normpath(os.path.join(vc_common_tool_dir, '../../VC/bin/vcvars32.bat'))
        return result
    ```
    ↓
    ```Python:PythonBindings.py
    def vcvars(platform_tag):
        result = 'C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Auxiliary/Build/vcvars64.bat'
        return result
    ```

## できなかったこと
* パスに半角スペースがある状態でのビルド
* PIP インストール対応（公式が手動コピーなので仕方ないかも）

## 参考
* SIP  
https://www.riverbankcomputing.com/software/  
（ダウンロードページには目的のバージョンがないのでリポジトリのページへ）
* Building the FBX SDK for Python 3.7  
http://www.morganhenty.com/2020/05/03/building_fbx_sdk_for_python/  
