FROM jupyter/base-notebook

# Install system dependencies for computer vision packages
USER root
RUN apt update && apt install -y build-essential libgl1 libglib2.0-0 libsm6 libxrender1 libxext6
USER $NB_USER

# Copy the repository into the container
COPY --chown=${NB_UID} . /opt/misinformation

# Install the Python package
RUN python -m pip install /opt/misinformation

# Install additional dependencies for running the notebooks
RUN python -m pip install -r /opt/misinformation/requirements.txt

# Make JupyterLab the default for this application
ENV JUPYTER_ENABLE_LAB=yes

# Export where the data is located
ENV XDG_DATA_HOME=/opt/misinformation/data

# Copy notebooks into the home directory
RUN rm -rf $HOME/work
RUN cp /opt/misinformation/notebooks/*.ipynb $HOME

ARG GOOGLE_CREDS
ENV GOOGLE_APPLICATION_CREDENTIALS=credentials.json
RUN echo ${GOOGLE_CREDS} > $GOOGLE_APPLICATION_CREDENTIALS
# Bundle the pre-built models (that are downloaded on demand) into the
# Docker image.
RUN misinformation_prefetch_models
