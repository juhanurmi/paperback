extern crate paperback_core;
use paperback_core::latest as paperback; 
use paperback::Backup;
use paperback::ToPdf;

fn backup(secret: Vec<u8>, num_shards: u32, quorum_size: u32, sealed: bool, print: bool) -> Result<(), Box<dyn std::error::Error>> {
    let backup = if sealed {
        Backup::new_sealed(quorum_size, &secret)
    } else {
        Backup::new(quorum_size, &secret)
    }?;

    let main_document = backup.main_document().clone();
    
    let shards = (0..num_shards)
        .map(|_| backup.next_shard().unwrap())
        .map(|s| (s.id(), s.encrypt().unwrap()))
        .collect::<Vec<_>>();

    if print {
        println!("\n----- BEGIN MAIN DOCUMENT -----");
        println!("Document-ID: {}", main_document.id());
        println!("Checksum: {}", main_document.checksum_string());
        main_document.to_pdf()?;
        println!("----- END MAIN DOCUMENT -----");

        for (shard_id, (_shard, codewords)) in shards {
            println!("\n----- BEGIN SHARD -----");
            println!("Shard-ID: {}", shard_id);
            println!("Keywords: {}", codewords.join(" "));
            println!("----- END SHARD -----");
        }
    }
    
    Ok(())
}

fn main() {
    use std::time::Instant; // Test execution time
    let now = Instant::now(); // Start

    let print: bool = true;
    let sealed: bool = false;
    let quorum_size: u32 = 3;
    let num_shards: u32 = 6;
    let secret: Vec<u8> = vec![123; 7500];
    match backup(secret, num_shards, quorum_size, sealed, print) {
        Ok(mut _result) => {
        },
	Err(e) => {
            println!("Failed to connect: {}", e);
        }
    }

    println!("Elapsed: {:.2?}", now.elapsed()); // Stop execution time
}
