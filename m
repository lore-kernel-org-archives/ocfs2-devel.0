From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 21 Sep 2011 10:15:20 -0700
Subject: [Ocfs2-devel] Some fsck perf numbers
In-Reply-To: <4E73BED3.2090106@oracle.com>
References: <4E73BED3.2090106@oracle.com>
Message-ID: <4E7A1BA8.8070803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So I have another set of numbers this time with a volume containing
15 million files. 500 kernel trees. 2T volume.

Two sets of numbers. First one is vanilla fsck. Second is with all the
changes. The difference from the earlier run is that this one also includes
improvement in pass 2.

Pass 2: Checking directory entries
   I/O read disk/cache: 7192MB / 584MB, write: 0MB, rate: 2.99MB/s
   Times real: 2600.512s, user: 177.007s, sys: 29.523s
   I/O read disk/cache: 3902MB / 3937MB, write: 0MB, rate: 22.84MB/s
   Times real: 343.183s, user: 136.080s, sys: 13.458s

The overall numbers are also much improved. 135 mins v/s 36 mins.
Almost 1/4 of the time.

   Cache size: 827MB
   I/O read disk/cache: 138751MB / 778MB, write: 0MB, rate: 17.11MB/s
   Times real: 8154.586s, user: 581.073s, sys: 111.422s
   Cache size: 826MB
   I/O read disk/cache: 68729MB / 164MB, write: 0MB, rate: 31.19MB/s
   Times real: 2208.544s, user: 437.513s, sys: 39.672s

hdparm -t numbers for this LUN ranges from 35 to 70 MB/s.

Per pass numbers here.
================================================================================
   # of inodes with depth 0/1/2/3/4/5: 8442506/0/0/0/0/0
   # of orphaned inodes found/deleted: 0/0

     15561511 regular files (7125500 inlines, 0 reflinks)
       967006 directories (960505 inlines)
            0 character device files
            0 block device files
            0 fifos
            0 links
          500 symbolic links (500 fast symbolic links)
            0 sockets

Pass 0a: Checking cluster allocation chains
   I/O read disk/cache: 66MB / 1MB, write: 0MB, rate: 0.68MB/s
   Times real: 97.423s, user: 0.410s, sys: 0.281s
   I/O read disk/cache: 66MB / 66MB, write: 0MB, rate: 9.76MB/s
   Times real: 13.428s, user: 0.408s, sys: 0.176s

Pass 0b: Checking inode allocation chains
   I/O read disk/cache: 64696MB / 128MB, write: 0MB, rate: 42.36MB/s
   Times real: 1530.270s, user: 80.163s, sys: 24.728s
   I/O read disk/cache: 64MB / 190MB, write: 0MB, rate: 30.04MB/s
   Times real: 8.423s, user: 1.882s, sys: 0.325s

Pass 0c: Checking extent block allocation chains
   I/O read disk/cache: 2101MB / 3MB, write: 0MB, rate: 43.77MB/s
   Times real: 48.052s, user: 2.616s, sys: 0.785s
   I/O read disk/cache: 3MB / 3MB, write: 0MB, rate: 19.56MB/s
   Times real: 0.256s, user: 0.053s, sys: 0.007s

Pass 1: Checking inodes and blocks
   I/O read disk/cache: 64699MB / 66MB, write: 0MB, rate: 16.85MB/s
   Times real: 3842.447s, user: 285.016s, sys: 56.104s
   I/O read disk/cache: 64698MB / 66MB, write: 0MB, rate: 35.79MB/s
   Times real: 1809.436s, user: 265.293s, sys: 25.705s

Pass 2: Checking directory entries
   I/O read disk/cache: 7192MB / 584MB, write: 0MB, rate: 2.99MB/s
   Times real: 2600.512s, user: 177.007s, sys: 29.523s
   I/O read disk/cache: 3902MB / 3937MB, write: 0MB, rate: 22.84MB/s
   Times real: 343.183s, user: 136.080s, sys: 13.458s

Pass 3: Checking directory connectivity
   I/O read disk/cache: 1MB / 1MB, write: 0MB, rate: 2.29MB/s
   Times real: 0.437s, user: 0.431s, sys: 0.000s
   I/O read disk/cache: 1MB / 1MB, write: 0MB, rate: 2.34MB/s
   Times real: 0.428s, user: 0.424s, sys: 0.000s

Pass 4a: Checking for orphaned inodes
   I/O read disk/cache: 1MB / 1MB, write: 0MB, rate: 164.28MB/s
   Times real: 0.006s, user: 0.001s, sys: 0.000s
   I/O read disk/cache: 1MB / 1MB, write: 0MB, rate: 128.49MB/s
   Times real: 0.008s, user: 0.000s, sys: 0.000s

Pass 4b: Checking inodes link counts
   I/O read disk/cache: 0MB / 0MB, write: 0MB, rate: 0.00MB/s
   Times real: 35.440s, user: 35.430s, sys: 0.001s
   I/O read disk/cache: 0MB / 0MB, write: 0MB, rate: 0.00MB/s
   Times real: 33.382s, user: 33.374s, sys: 0.001s

================================================================================


On 09/16/2011 02:25 PM, Sunil Mushran wrote:
> I have been playing with fsck.ocfs2. Performance-wise. Have some
> interesting numbers to share.
>
> This volume is 2T in size with 1.5 million files. Many exploded
> kernels trees + some large files. The particulars are listed below.
>
> I did 3 runs.
>
> The first set of numbers are vanilla fsck.
>
> In the second one, I added prefill before each of the allocator
> chain scan. It fills up the cache before calling verify_chain().
> The logic is simple. After the bitmap inode is read, it issues aios
> for all first level groups. 243 of them. Then it reads the next_group
> of all and again issues aios. And so on.
>
> There is another piece of code in vanilla fsck. It is called precache.
> The idea there is similar. During the suballocator scans, it force reads
> the entire block group. The idea is to warm the cache for Pass 1. The
> problem, as we know, is that precache only works when the cache is large
> enough. In this run, it is not. The second set disables precache.
>
> So set 2 enables prefill and disables precache.
>
> In the third set, I also increased the size of the buffer in
> open_inode_scan(). It was reading 32K to 1M. I upped it to one suballoc
> block group. So 4MB max.
>
> ================================================================
>     Number of blocks:   536870202
>     Block size:         4096
>     Number of clusters: 536870202
>     Cluster size:       4096
>     Number of slots:    1
>
>     # of inodes with depth 0/1/2/3/4/5: 844325/16/0/0/0/0
>     # of orphaned inodes found/deleted: 0/0
>
>        1556247 regular files (712550 inlines, 0 reflinks)
>          96706 directories (96056 inlines)
>              0 character device files
>              0 block device files
>              0 fifos
>              0 links
>             50 symbolic links (50 fast symbolic links)
>              0 sockets
>
> Inline rule!
> ================================================================
>
>     Cache size: 1017MB
>     I/O read disk/cache: 15519MB / 511MB, write: 0MB, rate: 17.48MB/s
>     Times real: 917.039s, user: 59.392s, sys: 10.997s
>
>     Cache size: 1016MB
>     I/O read disk/cache: 6956MB / 582MB, write: 0MB, rate: 11.93MB/s
>     Times real: 631.968s, user: 48.739s, sys: 7.591s
>
>     Cache size: 1019MB
>     I/O read disk/cache: 6956MB / 582MB, write: 0MB, rate: 17.79MB/s
>     Times real: 423.701s, user: 47.015s, sys: 4.621s
>
> These are global numbers. I calculate numbers per pass and keep adding
> them. Notice how the first set reads almost double the amount from disk.
> It is because the inode allocator had 6G and the box had 1G of cache.
> Pre reading the inodes hurts us. The third set reads the same amount as
> second but has a better thruput. That's because open_inode_scan is reading
> the entire block group.
>
> Meaning we don't need precache. Instead we could increase the buffer size
> in open_scan().
>
> Now numbers per pass.
>
> ================================================================
> Pass 0a: Checking cluster allocation chains
>     I/O read disk/cache: 66MB / 1MB, write: 0MB, rate: 0.68MB/s
>     Times real: 97.072s, user: 0.423s, sys: 0.280s
>
>     I/O read disk/cache: 66MB / 66MB, write: 0MB, rate: 10.27MB/s
>     Times real: 12.756s, user: 0.343s, sys: 0.156s
>
>     I/O read disk/cache: 66MB / 66MB, write: 0MB, rate: 10.53MB/s
>     Times real: 12.443s, user: 0.398s, sys: 0.178s
>
> In 2 and 3, the cluster groups are read using aio. And it helps!
> ================================================================
>
> Pass 0b: Checking inode allocation chains
>     I/O read disk/cache: 6471MB / 14MB, write: 0MB, rate: 42.93MB/s
>     Times real: 151.066s, user: 8.222s, sys: 2.512s
>
>     I/O read disk/cache: 7MB / 20MB, write: 0MB, rate: 26.85MB/s
>     Times real: 0.968s, user: 0.186s, sys: 0.025s
>
>     I/O read disk/cache: 7MB / 20MB, write: 0MB, rate: 14.93MB/s
>     Times real: 1.741s, user: 0.234s, sys: 0.034s
>
> Disabling precache in 2 and 3 helps tremendously.
> ================================================================
>
> Pass 0c: Checking extent block allocation chains
>     I/O read disk/cache: 2101MB / 3MB, write: 0MB, rate: 42.70MB/s
>     Times real: 49.249s, user: 2.628s, sys: 0.804s
>
>     I/O read disk/cache: 3MB / 3MB, write: 0MB, rate: 19.68MB/s
>     Times real: 0.254s, user: 0.053s, sys: 0.007s
>
>     I/O read disk/cache: 3MB / 3MB, write: 0MB, rate: 19.97MB/s
>     Times real: 0.250s, user: 0.056s, sys: 0.006s
>
> Disabling precache in 2 and 3 helps. The caveat here is that this
> volume has mainly files with depth 0.
> ================================================================
>
> Pass 1: Checking inodes and blocks
>     I/O read disk/cache: 6532MB / 67MB, write: 0MB, rate: 13.64MB/s
>     Times real: 483.811s, user: 31.493s, sys: 5.995s
>
>     I/O read disk/cache: 6531MB / 68MB, write: 0MB, rate: 13.70MB/s
>     Times real: 481.581s, user: 31.039s, sys: 5.958s
>
>     I/O read disk/cache: 6531MB / 68MB, write: 0MB, rate: 24.34MB/s
>     Times real: 271.107s, user: 29.263s, sys: 2.982s
>
> Set 3 is best because of the large buffer size in open_scan.
> ================================================================
>
> The rest of the passes are unchanged. It will look at that next.
>
> Comments welcome.
>
> Sunil
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
