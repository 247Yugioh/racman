state("racman") {}

startup {
    print("Starting");
}

init {
    System.IO.MemoryMappedFiles.MemoryMappedFile mmf = System.IO.MemoryMappedFiles.MemoryMappedFile.OpenExisting("racman-autosplitter");
    System.IO.MemoryMappedFiles.MemoryMappedViewStream stream = mmf.CreateViewStream();
    vars.reader = new System.IO.BinaryReader(stream);
    
    vars.reader.BaseStream.Position = 0;

    current.mapTimer = vars.reader.ReadSingle();
    current.checkpointTimer = vars.reader.ReadSingle();
    current.onLoad = vars.reader.ReadUInt32();
    current.planet = vars.reader.ReadUInt32();
    current.loadingPlanet = vars.reader.ReadUInt32();

    vars.gameTimer = 0.0f;
    vars.tempTimer = current.mapTimer;
}

update {
    vars.reader.BaseStream.Position = 0;

    current.mapTimer = vars.reader.ReadSingle();
    current.checkpointTimer = vars.reader.ReadSingle();
    current.onLoad = vars.reader.ReadByte();
    current.planet = vars.reader.ReadByte();
    current.loadingPlanet = vars.reader.ReadByte();

    if(current.checkpointTimer != old.checkpointTimer)
    {
       if(current.onLoad = 0)
       {
            if(old.planet = current.loadingPlanet)
            {
                float delta = current.mapTimer - vars.tempTimer;

                if (delta > 0.0f)
                {
                    vars.gameTimer += delta;
                }

                vars.tempTimer = current.mapTimer;
            }
       }
    }
}


reset {

}

start {

}

split {

}

gameTime {
    return TimeSpan.FromSeconds(vars.gameTimer);
}

isLoading
{
    return true;
} 
