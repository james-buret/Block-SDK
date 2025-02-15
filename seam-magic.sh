echo "                                ./(,                                      
                                     *#%%%(                                     
                                     /%%%%(.                                    
                                    .(%%%%#,                                    
             .                      ,#%%%%%/                      .             
           *%%%%#.                  *%%%%%%(.                 .(%%%%/           
            /%%%%%%#*              .(%%%%%%#,              ,(#%%%%%(.           
             ./#%%%%%%#*           ,#%%%%%%%*           ,#%%%%%%%(.             
                (%%%%%%%%#/.       *%%%%%%%%/.      .*#%%%%%%%%(.               
                 .(%%%%%%%%%#(,   .(%%%%%%%%#,   .*#%%%%%%%%%#.                 
                   .(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#,                   
                     .(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#,                     
                       .#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#,                       
                        .%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*                        
            ...,,**//(#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#(//**,,...            
 /#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#/.
,%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/
    ...,,*/(##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#(//*,...    
                       .(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(,                       
                        ,%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/                        
                      .(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%,                      
                    .(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#,                    
                  .(%%%%%%%%%%#*../%%%%%%%%%%(,..#%%%%%%%%%%#,                  
                 (%%%%%%%%%(,      /%%%%%%%%(.     ./#%%%%%%%%#.                
              .(%%%%%%%%(,         ,#%%%%%%%/         ./#%%%%%%%#,              
            ./#%%%%%#/.            .(%%%%%%#,             *#%%%%%%(.            
           *%%%%%#/                 /%%%%%%(.                *#%%%%%/           
            *##,                    *#%%%%%/                    .##(.           
                                    ,(%%%%#*                                    
                                     (%%%%#.                                    
                                     *#%%%(                                     
                                     .(%%#,                                     
"
echo "Welcome to the Seam Block Editor! Let's make some Seam Magic and create a new block together."
echo "[1/3] What should your block be called? (Visible to users): "
read -r name

echo "[2/3] What's the 1 word title of your block? (used only in code): "
read -r shortName

echo "[3/3] What's the short description of your block?"
read -r description

echo "Awesome! Sewing your $name block together..."

# Add the new block to the types dictionary
output="src/blocks/types.tsx"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sed -i -e '$ d' $output
elif [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e '$ d' $output
else
        echo "❌ Unable to create ${name}Block -- unsupported operating system."
        exit 1
fi

echo "  \"$shortName\": { 
        type: \"$shortName\",
        displayName: \"$name\",
        displayDescription: \"$description\",
        emptyTitle: \"Empty $name Block\",
        emptySubtitle: \"Tap here to setup your $name block!\",
        icon: \"${shortName}Icon\", // TODO: insert your block icon here
        deprecated: false,
        feedConstrained: false,
        doesBlockPost: false
    },
};" >> $output
echo "✅ Added $name to types.tsx"

# Create a template file for the new block
newBlock="src/blocks/${shortName}Block.tsx"
cp "src/blocks/BlockTemplate.txt" $newBlock


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sed -i "s/%NAME%/${shortName}/g" $newBlock
        echo "✅ Created ${shortName}Block.tsx for your new block"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/%NAME%/${shortName}/g" $newBlock
        echo "✅ Created ${shortName}Block.tsx for your new block"
fi

# Add the new block to the block factory
placeholder="\/\/ new blocks go here"
importBlock="import ${shortName}Block from \'./${shortName}Block\'
"
newBlockCase="case \"$shortName\": return new ${shortName}Block(model, theme)\\n      $placeholder"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sed -i "s/${placeholder}/${newBlockCase}/g" "src/blocks/BlockFactory.tsx"
        sed -i '1i\
'"$importBlock"'
' "src/blocks/BlockFactory.tsx"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/${placeholder}/${newBlockCase}/g" "src/blocks/BlockFactory.tsx"
        sed -i '' '1i\
'"$importBlock"'
' "src/blocks/BlockFactory.tsx"
fi

echo "✅ Added ${name} to the BlockFactory.tsx"

# Use your custom block as default in App.tsx
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sed -i "s/%NAME%/${shortName}/g" "src/App.tsx"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/%NAME%/${shortName}/g" "src/App.tsx"
fi
echo "✅ Using your ${name} block as default in App.tsx"

echo "

██████╗░██╗░░░░░░█████╗░░█████╗░██╗░░██╗  ░█████╗░██████╗░███████╗░█████╗░████████╗███████╗██████╗░██╗
██╔══██╗██║░░░░░██╔══██╗██╔══██╗██║░██╔╝  ██╔══██╗██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔══██╗██║
██████╦╝██║░░░░░██║░░██║██║░░╚═╝█████═╝░  ██║░░╚═╝██████╔╝█████╗░░███████║░░░██║░░░█████╗░░██║░░██║██║
██╔══██╗██║░░░░░██║░░██║██║░░██╗██╔═██╗░  ██║░░██╗██╔══██╗██╔══╝░░██╔══██║░░░██║░░░██╔══╝░░██║░░██║╚═╝
██████╦╝███████╗╚█████╔╝╚█████╔╝██║░╚██╗  ╚█████╔╝██║░░██║███████╗██║░░██║░░░██║░░░███████╗██████╔╝██╗
╚═════╝░╚══════╝░╚════╝░░╚════╝░╚═╝░░╚═╝  ░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░╚═╝
"

open $newBlock
echo "When you're ready, run yarn start to see your block in action!"