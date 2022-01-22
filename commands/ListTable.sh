    
    #!/bin/bash
    
    
    listing=`ls | wc -l`
    if [ $listing -eq 0 ]
        then echo "No tables found"
    else ls
    fi  