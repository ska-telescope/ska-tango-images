extract-image-arg()
{
    sed < images/${OCI_IMAGE}/Dockerfile -rn "s/^ARG $1=\"\\\$\\{CAR_OCI_REGISTRY_HOST\\}\\/(ska-tango-images-[^:]*).*\"/\\1/p"
}

