function update_codes -d 'Update packages from local git repos'
  type -q pyenv; and set -lx PATH (string match -ev (pyenv root) $PATH)
  if set -q $argv[1]
    conda upgrade --all -y
    conda clean --index-cache --packages --tarballs -y
    set modules_backup $LOADEDMODULES
    module purge
    for i in pymatgen custodian fireworks mpworks atomate
      update_codes $i
    end
    module load (string split ':' -- $modules_backup)
  else
    for i in $argv
      set code_path $MP_CODES_ROOT/$i
      if [ -d $code_path ]
        echo -e "\nUpdating $i in $code_path:"
        cd $code_path
        git pull
        pip install -e .
        cd $dirprev[-1]
      end
    end
  end
end