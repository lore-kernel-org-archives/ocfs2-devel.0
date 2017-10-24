From: Larry Chen <lchen@suse.com>
Date: Tue, 24 Oct 2017 18:39:36 +0800
Subject: [Ocfs2-devel] a puzzle about is_global_system_inode function
Message-ID: <2061999c-f11b-b50d-55e4-09c847a5f25d@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

Function is_global_system_inode checks whether the type is
in the range [OCFS2_FIRST_ONLINE_SYSTEM_INODE , 
OCFS2_LAST_GLOBAL_SYSTEM_INODE ].
But why the range does not include GLOBAL_INODE_ALLOC_SYSTEM_INODE ??

enum {
 ????? ....
 ?????? GLOBAL_INODE_ALLOC_SYSTEM_INODE,
 ??????? SLOT_MAP_SYSTEM_INODE,
#define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
 ??????? HEARTBEAT_SYSTEM_INODE,
 ??????? GLOBAL_BITMAP_SYSTEM_INODE,
 ??????? USER_QUOTA_SYSTEM_INODE,
 ??????? GROUP_QUOTA_SYSTEM_INODE,
#define OCFS2_LAST_GLOBAL_SYSTEM_INODE GROUP_QUOTA_SYSTEM_INODE
 ??? ....
}

Thanks
Larry Chen
