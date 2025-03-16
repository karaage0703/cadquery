# build stage
FROM continuumio/miniconda3

RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0

WORKDIR /workspace

# refresh system font cache
# フォントを扱う際に推奨されているが意味があるか不明です...
# ENV FONTCONFIG_PATH=/etc/fonts
# ENV FONTCONFIG_FILE=/etc/fonts/fonts.conf
# RUN fc-cache -f -v

RUN conda install -n base -c conda-forge cadquery -y

# 新しい Conda 環境 `cq_env` を作成し、Python 3.10 でセットアップ
RUN conda create -n cq_env python=3.10 -y

# `cq_env` をアクティブにする設定
RUN echo "source /opt/conda/bin/activate cq_env" >> ~/.bashrc

# `cq_env` に `cadquery` をインストール
RUN /bin/bash -c "source /opt/conda/bin/activate cq_env && conda install -c conda-forge cadquery -y"

# `cq_env` に `ocp-tessellate` をインストール
RUN /bin/bash -c "source /opt/conda/bin/activate cq_env && pip install --no-cache-dir git+https://github.com/bernhard-42/ocp-tessellate.git"

# **既存の `ezdxf` を削除し、正しいバージョンを強制インストール**
RUN /bin/bash -c "source /opt/conda/bin/activate cq_env && pip uninstall -y ezdxf && pip install --no-cache-dir 'ezdxf>=0.17,<1.0'"

# `cq_env` に `vscode-ocp-cad-viewer` を GitHub からインストール
RUN /bin/bash -c "source /opt/conda/bin/activate cq_env && pip install --no-cache-dir git+https://github.com/bernhard-42/vscode-ocp-cad-viewer.git"

CMD ["bash"]