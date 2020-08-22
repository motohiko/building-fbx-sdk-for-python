# Building the FBX SDK for Python
FBX Python SDK のビルド方法
## Python バージョン
* 3.8.3
## FBX バージョン
* 2020.1.1
## OS/CPU
* Windows 10 Pro 64bit
* i7-8500Y
## コンパイラ
* Microsoft Visual Studio 2019 Community
## 注意事項（重要）
* FBX Python Bindings の パスに半角スペースを含めない
    * パスに空白があるとビルドに失敗するので空白を除去するか、インストールしたフォルダを別の場所にコピーする
    * FBX Python Bindings というフォルダ名がＮＧ
* sip-4.19.3 を使うこと
    * FBX Python Bindings の readme.txt にこのバージョンで作成したと書いてある
    * これより新しいバージョンを使用すると以下のエラーが出る
        * size_t の定義 
        * override (C++11)
        * privateの代入演算子オーバーロード
## ビルド手順
1. sip-4.19.3 を解凍 (https://www.riverbankcomputing.com/hg/sip から入手)  
configure.py を実行  
環境変数 SIP_ROOT にパスを登録  
2. FBX SDK 2020.1.1 をインストール  
環境変数 FBXSDK_ROOT にパスを登録  
3. FBX Python Bindings 2020.1.1 をインストール  
後述の修正を当てる  
2020.1.1\PythonBindings.pyを実行してビルド  
2020.1.1\build\Distrib\site-packages\fbx\* を site-packages へコピー
## 修正箇所

* 'AMD64' の判定を追加  
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
* Visual Studio のパスを修正  
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
* パスに空白文字がある状態でのビルド
* PIP インストール対応（公式が手動コピーなので仕方ないかも）
## 参考
* SIP  
https://www.riverbankcomputing.com/software/  
（ダウンロードページには目的のバージョンがないのでリポジトリのページへ）
* Building the FBX SDK for Python 3.7  
http://www.morganhenty.com/2020/05/03/building_fbx_sdk_for_python/  
