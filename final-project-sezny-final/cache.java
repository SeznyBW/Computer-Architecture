import java.util.Scanner;


public class cache {

	static int associativity = 2;          // Associativity of cache
	static int blocksize_bytes = 32;       // Cache Block size in bytes
	static int cachesize_kb = 64;          // Cache size in KB
	static int miss_penalty = 30;

	public static void print_usage()
	{
	  System.out.println("Usage: gunzip2 -c <tracefile> | java cache -a assoc -l blksz -s size -mp mispen\n");
	  System.out.println("  tracefile : The memory trace file\n");
	  System.out.println("  -a assoc : The associativity of the cache\n");
	  System.out.println("  -l blksz : The blocksize (in bytes) of the cache\n");
	  System.out.println("  -s size : The size (in KB) of the cache\n");
	  System.out.println("  -mp mispen: The miss penalty (in cycles) of a miss\n");
	  System.exit(0);
	}

	public static void main(String[] args) {
		  long address = 0;
		  int loadstore = 0;
		  int icount = 0;
		  int index;
		  long tag;
		  boolean found = false;
		  int memory_access=0;
		  int instructions = 0;
		  int store_hits=0;
		  int store_misses=0;
		  int load_hits=0;
		  int load_misses=0;
		  int dirty_evictions=0;
		  boolean hit = false;

		  int i = 0;
		  int j = 0;
		  // Process the command line arguments
		 // Process the command line arguments
		  while (j < args.length) {
		    if (args[j].equals("-a")) {
		      j++;
		      if (j >= args.length)
		        print_usage();
		      associativity = Integer.parseInt(args[j]);
		      j++;
		    } else if (args[j].equals("-l")) {
		      j++;
		      if (j >= args.length)
		        print_usage ();
		      blocksize_bytes = Integer.parseInt(args[j]);
		      j++;
		    } else if (args[j].equals("-s")) {
		      j++;
		      if (j >= args.length)
		        print_usage ();
		      cachesize_kb = Integer.parseInt(args[j]);
		      j++;
		    } else if (args[j].equals("-mp")) {
		      j++;
		      if (j >= args.length)
		        print_usage ();
		      miss_penalty = Integer.parseInt(args[j]);
		      j++;
		    } else {
		    	System.out.println("Bad argument: " + args[j]);
		      print_usage ();
		    }
		  }


		  // print out cache configuration
		  System.out.println("Cache parameters:\n");
		  System.out.format("Cache Size (KB)\t\t\t%d\n", cachesize_kb);
		  System.out.format("Cache Associativity\t\t%d\n", associativity);
		  System.out.format("Cache Block Size (bytes)\t%d\n", blocksize_bytes);
		  System.out.format("Miss penalty (cyc)\t\t%d\n",miss_penalty);
		  System.out.println("\n");

		  //make cache
		  int rows = (cachesize_kb*1024)/(blocksize_bytes*associativity);
		  long cachearray[][][] = new long[rows][associativity][3];
		  //and tracker for which block has been used most recently
		  int[][] recent = new int[rows][associativity];

		  Scanner sc = new Scanner(System.in);
		  while (sc.hasNextLine()) {
		      if (sc.hasNext()){
			sc.next(); //get rid of hashmark
			loadstore = sc.nextInt();
			address = sc.nextLong(16); //16 specifies it's in hex
			icount = sc.nextInt();

			// Code to print out just the first 10 addresses.  You'll want to delete
		    // this part once you get things going.
		/*	if(i<10){
			    System.out.println("\t " + loadstore + " " + Long.toHexString(address) + " " + icount);
			}
			else{
			    System.exit(0);
			}*/
			i++;

			//here is where you will want to process your memory accesses
			instructions += icount;
			memory_access += 1;
			index = (int)(address / blocksize_bytes) % rows;
			tag = address / (blocksize_bytes*rows);
			for (int k=0; k<associativity; k++){
				if(cachearray[index][k][2]!=1){
					found=true;
					cachearray[index][k][0]=tag;
					cachearray[index][k][2]=1;
					if(loadstore==0){
						load_misses+=1;
						cachearray[index][k][1]=0;
					}
					else{
						store_misses+=1;
						cachearray[index][k][1]=1;
					}
					for(int n=0; n<associativity-1; n++){
						if (recent[index][associativity-2-n]!=0){
							recent[index][associativity-1-n]=recent[index][associativity-2-n];
						}
					}
					recent[index][0]=k+1;
					break;
				}
				
				if (cachearray[index][k][0]==tag){
					hit=true;				
					found=true;
					if(loadstore==0){
						load_hits+=1;
					}
					else{
						store_hits+=1;
						cachearray[index][k][1]=1;
					}
					for(int l=0; l<associativity; l++){
						if(recent[index][l]==k+1){
							for (int m=0; m<l; m++){
								recent[index][l-m]=recent[index][l-m-1];
							}
							recent[index][0]=k+1;
						}
					}
					break;
				}
			}

			if(found==false){
				int kick=recent[index][associativity-1];
				if (cachearray[index][kick-1][1]==1){
					dirty_evictions+=1;
				}
				cachearray[index][kick-1][0]=tag;
				if (loadstore==0){
					load_misses+=1;
					cachearray[index][kick-1][1]=0;
				}
				else{
					store_misses+=1;
					cachearray[index][kick-1][1]=1;
				}
				for(int n=0; n<associativity-1; n++){
					if (recent[index][associativity-2-n]!=0){
						recent[index][associativity-1-n]=recent[index][associativity-2-n];
					}
				}
				recent[index][0]=kick;
			}

			found=false;
/*			System.out.println("Address: " + Long.toBinaryString(address) + "     Tag: " + Long.toBinaryString(tag) + "     Tag dec: " + tag);
			for (int a=0; a<associativity; a++){
				System.out.format("\t %d", cachearray[0][a][0]);
			}
			System.out.println();
			for (int b=0; b<associativity; b++){
				System.out.format("\t %d", recent[0][b]);
			}
			System.out.println();

*/
		/*	System.out.println(Long.toBinaryString(address) + "       " + hit);
			hit=false;
*/
/*			System.out.println("Address: " + Long.toBinaryString(address));
			System.out.println("Hit: " + hit);
			System.out.println("Index: " + Integer.toBinaryString(index));
			System.out.println("Tag binary: " + Long.toBinaryString(tag) + "     Tag Dec: " + tag);
			for (int a=0; a<associativity; a++){
				System.out.format("\t %d", cachearray[0][a][0]);
			}
			System.out.println();
			for (int b=0; b<associativity; b++){
				System.out.format("\t %d", recent[0][b]);
			}
			System.out.println();
			try{
				Thread.sleep(5000);
			}
			catch (InterruptedException e) {
			}

*/
			hit=false;

		      } else {
			  break;
		      }

		  }
		  // Here is where you want to print out stats
		  System.out.format("Lines found = %d \n",i);
		  System.out.println("Simulation results:\n");
		  //  Use your simulator to output the following statistics.  The
		  //  print statements are provided, just replace the question marks with
		  //  your calcuations.
		  int exec = instructions + (load_misses+store_misses)*miss_penalty + dirty_evictions*2;
		  float average = (float)((load_misses+store_misses)*miss_penalty + dirty_evictions*2) / memory_access;
		  float memcpi=(float)((load_misses+store_misses)*miss_penalty + dirty_evictions*2)/instructions;

		  System.out.format("\texecution time %d cycles\n", exec);
		  System.out.format("\tinstructions %d\n", instructions);
		  System.out.format("\tmemory accesses %d\n", memory_access);
		  System.out.format("\toverall miss rate %.2f\n", (float)(load_misses+store_misses)/memory_access );
		  System.out.format("\tread miss rate %.2f\n", (float)load_misses/(load_misses+load_hits));
		  System.out.format("\tmemory CPI %.2f\n", memcpi);
		  System.out.format("\ttotal CPI %.2f\n", (float)exec/instructions);
		  System.out.format("\taverage memory access time %.2f cycles\n",  average);
		  System.out.format("dirty evictions %d\n", dirty_evictions);
		  System.out.format("load_misses %d\n", load_misses);
		  System.out.format("store_misses %d\n", store_misses);
		  System.out.format("load_hits %d\n", load_hits);
		  System.out.format("store_hits %d\n", store_hits);

	}

}
