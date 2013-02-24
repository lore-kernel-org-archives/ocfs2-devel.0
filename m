From: Jeff Liu <jeff.liu@oracle.com>
Date: Sun, 24 Feb 2013 21:42:30 +0800
Subject: [Ocfs2-devel] [RFC PATCH 0/3] copy-on-write extents mapping
In-Reply-To: <20130221180039.GX22221@lenny.home.zabbo.net>
References: <51244A15.2060508@oracle.com>
	<20130221152520.GA17067@quack.suse.cz>
	<20130221180039.GX22221@lenny.home.zabbo.net>
Message-ID: <512A18C6.6090601@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: zab@zabbo.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

Hi Jan and Zach,

Thanks for both of your comments and sorry for my too late response since I have to
think it over and run tests to gather the performance statistics.

On 02/22/2013 02:00 AM, Zach Brown wrote:
>>   Can you gather some performance numbers please - i.e. how long does it take
>> to map such file without FIEMAP_FLAG_COW and how long with it? I'm not
>> completely convinced it will make such a huge difference in practice (given
>> du(1) isn't very performance critical application).
> 
> Seconded.
> 
> I'd like to see measurements (wall time, cpu, ios) of the time it takes
> to find shared extents on a giant file *on a fresh uncached mount*.
> 
> Because this interface doesn't help the file system do the work more
> efficiently, the kernel still has to walk everything to see if its
> shared.  It just saves some syscalls and copying.
> 
> That's noise compared to the io/cache footprint of the operation.
Firstly, the results is really frustrating to me as there basically has no performance
improved against a 50GB file on OCFS2.

The result collected on a single node OCFS2:
/dev/sda5 on /ocfs2 type ocfs2 (rw,sync,_netdev,heartbeat=local)

Create a 50GB file, and create a reflinked file from it:
$ dd if=/dev/zero of=testfile bs=1M count=50000
$ ./ocfs2_reflink testfile testfile_reflinked

Make the first 48GB COWed:
$ dd if=/dev/zero of=testfile_reflinked bs=1M count=46000 seek=0 conv=notrunc
46000+0 records in
46000+0 records out
48234496000 bytes (48 GB) copied, 1593.44 s, 30.3 MB/s

The original file has 968 shared extents:
$ ./cow_test testfile
Find 968 COW extents

After COWed, the target reflinked file has 101 extents in shared state:
The latest 101 extents are in shared state:
$ ./cow_test testfile_reflinked
Find 101 COW extents

No matter kernel is patched or not, there basically no performance improvements
although 12 times fiemap ioctl(2) are reduced:
Kernel non-patched:
$ time ./cow_test testfile_reflinked
Find 101 COW extents

real	0m0.006s
user	0m0.000s
sys	0m0.004s

Kernel patched:
$ time ./cow_test testfile_reflinked
Find 101 COW extents

real	0m0.006s
user	0m0.000s
sys	0m0.000s

Kernel non-patched:
$ strace -c ./cow_test testfile
Find 101 COW extents
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 74.36    0.000174          58         3           open
 25.64    0.000060          20         3           fstat
  0.00    0.000000           0         1           read
  0.00    0.000000           0         1           write
  0.00    0.000000           0         3           close
  0.00    0.000000           0         9           mmap
  0.00    0.000000           0         4           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         1           brk
  0.00    0.000000           0        16           ioctl
  0.00    0.000000           0         3         3 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00    0.000234                    47         3 total

Kernel patched:
$ strace -c ./cow_test testfile
Find 101 COW extents
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.002727        1364         2           ioctl
  0.00    0.000000           0         1           read
  0.00    0.000000           0         1           write
  0.00    0.000000           0         3           open
  0.00    0.000000           0         3           close
  0.00    0.000000           0         3           fstat
  0.00    0.000000           0         9           mmap
  0.00    0.000000           0         4           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         1           brk
  0.00    0.000000           0         3         3 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00    0.002727                    33         3 total

But I have another idea regarding the performance if considering the practical situations.
Generally, the end user would run du(1) against a partition with not only the reflinked files
but also includes normal files which are not contains any shared extents, or if the user check
up the shared extents for a previous reflinked file, but maybe this file has already totally
COWed, that is, now it does not contains any shared extent at all.

In either case, du(1) has to call fiemap to look through the extents against this kind of files
no matter it contains shared extents or not, that's would be an overhead(Yes, du(1) is not a
very performance critical application).

But with a prejudegement approach, we can bypass the normal files and lookup shared extents against
the COW file only.

On OCFS2, the reflinked file is indicated via OCFS2_HAS_REFCOUNT_FL flag insides inodes, here is a
proof-of-concept patch for OCFS2 on top of my previous patches, it was wrote for a quick demo purpose only:
/*
 * Don't trying to lookup shared extents for non-reflinked file.
 */
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index d75a731..a381041 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -774,6 +774,12 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
        down_read(&OCFS2_I(inode)->ip_alloc_sem);
 
+       if ((fieinfo->fi_flags & FIEMAP_FLAG_COW) &&
+           !(OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL)) {
+               ret = -ENODATA;
+               goto out_unlock;
+       }
+

For a 100Gb OCFS2 partition(This is the max partition I can created on my laptop),
$ ls -lh /ocfs2/
total 99G
-rwxrwxr-x+ 1 jeff jeff  13K Feb 24 16:54 cow_test_after
-rwxrwxr-x+ 1 jeff jeff  13K Feb 24 18:38 cow_test_default
-rwxrwxr-x+ 1 jeff jeff 459K Feb 24 20:14 du_non_patched
-rwxrwxr-x+ 1 jeff jeff 459K Feb 24 20:14 du_patched
drwxr-xr-x  2 jeff jeff 3.9K Feb 22 17:10 lost+found
-rw-rw-r--+ 1 jeff jeff  30G Feb 24 17:10 testfile
-rw-rw-r--+ 1 jeff jeff 9.8G Feb 24 19:03 testfile_02
-rw-rw-r--+ 1 jeff jeff 9.8G Feb 24 19:06 testfile_03
-rw-rw-r--+ 1 jeff jeff 9.8G Feb 24 19:10 testfile_04
-rw-rw-r--+ 1 jeff jeff 9.8G Feb 24 19:16 testfile_05
-rw-rw-r--  1 jeff jeff  30G Feb 24 20:02 testfile_reflinked

Before patching du(1) to aware of FIEMAP_FLAG_COW:
$ perf stat ./src/du_non_patched -E -sh /ocfs2/
99G	(59G)	/ocfs2/
70G	footprint

 Performance counter stats for './src/du_patched -E -sh /ocfs2/':

          7.443270 task-clock                #    0.042 CPUs utilized          
                32 context-switches          #    0.004 M/sec                  
                 2 cpu-migrations            #    0.269 K/sec                  
               321 page-faults               #    0.043 M/sec                  
        16,314,337 cycles                    #    2.192 GHz                    
         9,659,617 stalled-cycles-frontend   #   59.21% frontend cycles idle   
   <not supported> stalled-cycles-backend  
        14,734,763 instructions              #    0.90  insns per cycle        
                                             #    0.66  stalled cycles per insn
         3,256,351 branches                  #  437.489 M/sec                  
            38,433 branch-misses             #    1.18% of all branches        

       0.175917908 seconds time elapsed

After patching du(1):
$ perf stat ./src/du_patched -E -sh /ocfs2/
99G	(59G)	/ocfs2/
70G	footprint

 Performance counter stats for './src/du_patched -E -sh /ocfs2/':

          8.935251 task-clock                #    0.095 CPUs utilized          
                16 context-switches          #    0.002 M/sec                  
                 0 cpu-migrations            #    0.000 K/sec                  
               320 page-faults               #    0.036 M/sec                  
        11,661,240 cycles                    #    1.305 GHz                    
         6,007,876 stalled-cycles-frontend   #   51.52% frontend cycles idle   
   <not supported> stalled-cycles-backend  
        12,848,387 instructions              #    1.10  insns per cycle        
                                             #    0.47  stalled cycles per insn
         2,944,853 branches                  #  329.577 M/sec                  
            35,148 branch-misses             #    1.19% of all branches        

       0.093799219 seconds time elapsed


For individual files, both testfile_02 and testfile_03 are 10GB normal files
without shared extents:
$ ls -l testfile_02 testfile_03
-rw-rw-r--+ 1 jeff jeff 10485760000 Feb 24 19:03 testfile_02
-rw-rw-r--+ 1 jeff jeff 10485760000 Feb 24 19:06 testfile_03

Before patching du(1):
$ perf stat ./du_non_patched testfile_02
10240000	testfile_02

 Performance counter stats for './du_non_patched testfile_02':

          2.154475 task-clock                #    0.035 CPUs utilized          
                 7 context-switches          #    0.003 M/sec                  
                 0 cpu-migrations            #    0.000 K/sec                  
               297 page-faults               #    0.138 M/sec                  
         4,889,482 cycles                    #    2.269 GHz                    
         3,448,039 stalled-cycles-frontend   #   70.52% frontend cycles idle   
   <not supported> stalled-cycles-backend  
         2,811,093 instructions              #    0.57  insns per cycle        
                                             #    1.23  stalled cycles per insn
           500,471 branches                  #  232.294 M/sec                  
            13,712 branch-misses             #    2.74% of all branches        

       0.061926381 seconds time elapsed


After patching du(1):
$ perf stat ./du_patched testfile_03
10240000	testfile_03

 Performance counter stats for './du_patched testfile_03':

          2.321336 task-clock                #    0.059 CPUs utilized          
                 7 context-switches          #    0.003 M/sec                  
                 0 cpu-migrations            #    0.000 K/sec                  
               297 page-faults               #    0.128 M/sec                  
         5,044,049 cycles                    #    2.173 GHz                    
         3,596,109 stalled-cycles-frontend   #   71.29% frontend cycles idle   
   <not supported> stalled-cycles-backend  
         2,810,123 instructions              #    0.56  insns per cycle        
                                             #    1.28  stalled cycles per insn
           500,889 branches                  #  215.776 M/sec                  
            13,713 branch-misses             #    2.74% of all branches        

       0.039634019 seconds time elapsed

Does the results above looks make sense?  If yes, I still felt that it's not a formal approach
to detect reflinked files.  IMHO, if we can improve the stat(2)->getattr() to fill the mode
member with a flag to indicate that a file is reflinked/cow or not, it would be more convenient
to check as like S_ISREFLINK(stat.st_mode) from the user space since du(1) always fetching the
statistics per file disk space accounting.


Thanks,
-Jeff
