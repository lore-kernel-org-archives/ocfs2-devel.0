From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Fri Mar 19 17:15:16 2004
Subject: [Ocfs2-devel] Bug in ocfs_file_entry struct for 2.6
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B0E3E08@orsmsx410.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I was looking at the ocfs_file_entry struct in inc/ocfs.h

I noticed that it defines:

    __u16 dev_major;                  // NUMBER RANGE(0,65535)
    __u16 dev_minor;                  // NUMBER RANGE(0,65535)

So dev_major is not going to have a problem because they use 12 bits to
hold the major number.

But the dev_minor entry will be a problem because they use 20 bits to
hold the minor number in the 2.6.x kernel.

From a quick look at the code I'm not sure that this is an easy fix.  It
doesn't look like we can just change the structure (unless they have
__u20 and __u12 type variables??).  I'm saying that it doesn't look like
an easy fix because I think that this structure is put as is on the
disk, but maybe I am mistaken.

John



typedef struct _ocfs_file_entry         // CLASS
{
        ocfs_disk_lock disk_lock;       // DISKLOCK
        __u8 signature[8];              // CHAR[8]
        bool local_ext;                 // BOOL
        __u8 next_free_ext;             // NUMBER
RANGE(0,OCFS_MAX_FILE_ENTRY_EXTENTS)
        __s8 next_del;                  // DIRNODEINDEX
        __s32 granularity;              // NUMBER RANGE(-1,3)
        __u8 filename[OCFS_MAX_FILENAME_LENGTH];  //
CHAR[OCFS_MAX_FILENAME_LENGTH]
        __u16 filename_len;               // NUMBER
RANGE(0,OCFS_MAX_FILENAME_LENGTH)
        __u64 file_size;                  // NUMBER
RANGE(0,ULONG_LONG_MAX)
        __u64 alloc_size;                       // NUMBER
RANGE(0,ULONG_LONG_MAX)
        __u64 create_time;                // DATE
        __u64 modify_time;              // DATE
        ocfs_alloc_ext extents[OCFS_MAX_FILE_ENTRY_EXTENTS];  //
EXTENT[OCFS_MAX_FILE_ENTRY_EXTENTS]
        __u64 dir_node_ptr;               // NUMBER
RANGE(0,ULONG_LONG_MAX)
        __u64 this_sector;                // NUMBER
RANGE(0,ULONG_LONG_MAX)
        __u64 last_ext_ptr;               /* NUMBER
RANGE(0,ULONG_LONG_MAX)
                                             Points to the last
                                             allocated extent */
        __u32 sync_flags;                 // NUMBER RANGE(0,0)
        __u32 link_cnt;                   // NUMBER RANGE(0,UINT_MAX)
        __u32 attribs;                    // ATTRIBS
        __u32 prot_bits;                  // PERMS
        __u32 uid;                        // UID
        __u32 gid;                        // GID
        __u16 dev_major;                  // NUMBER RANGE(0,65535)
        __u16 dev_minor;                  // NUMBER RANGE(0,65535)
/* 32-bit: sizeof(fe) = 484 bytes */
/* 64-bit: sizeof(fe) = 488 bytes */
/* Need to account for that fact when the struct is extended. */
}
ocfs_file_entry;                          /
