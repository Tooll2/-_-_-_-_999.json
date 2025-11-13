# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail wavespeed@1.1.8
RUN comfy node install --exit-on-fail virtuoso-nodes
RUN comfy node install --exit-on-fail comfyui-supir@1.0.2
RUN comfy node install --exit-on-fail comfyui-rmbg@2.9.3
RUN comfy node install --exit-on-fail comfyui-custom-scripts@1.2.5
RUN comfy node install --exit-on-fail comfyui-florence2@1.0.6
RUN comfy node install --exit-on-fail comfyui-post-processing-nodes@1.0.1
RUN comfy node install --exit-on-fail comfyui-wd14-tagger@1.0.1
RUN pip install imageio
RUN for dir in /comfyui/custom_nodes/*; do \
  if [ -f "$dir/requirements.txt" ]; then \
    pip install -r "$dir/requirements.txt"; \
  fi; \
done

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Kijai/flux-fp8/resolve/main/flux-vae-bf16.safetensors --relative-path models/vae --filename flux-vae-bf16.safetensors
RUN comfy model download --url https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors --relative-path models/clip --filename t5xxl_fp8_e4m3fn.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/stable-diffusion-3.5-fp8/resolve/main/text_encoders/clip_l.safetensors --relative-path models/clip --filename clip_l.safetensors
RUN comfy model download --url https://huggingface.co/Maxivi/SDXLLightning/resolve/main/jibMixRealisticXL_v10Lightning46Step.safetensors --relative-path models/checkpoints --filename jibMixRealisticXL_v10Lightning46Step.safetensors
RUN comfy model download --url https://huggingface.co/Kijai/SUPIR_pruned/resolve/main/SUPIR-v0Q_fp16.safetensors --relative-path models/checkpoints --filename SUPIR-v0Q_fp16.safetensors
RUN comfy model download --url https://huggingface.co/Kijai/SUPIR_pruned/resolve/main/SUPIR-v0F_fp16.safetensors --relative-path models/checkpoints --filename SUPIR-v0F_fp16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors --relative-path models/diffusion_models --filename flux1-dev-kontext_fp8_scaled.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
