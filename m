From: alex chen <alex.chen@huawei.com>
Date: Tue, 24 Oct 2017 20:35:10 +0800
Subject: [Ocfs2-devel] a puzzle about is_global_system_inode function
In-Reply-To: <2061999c-f11b-b50d-55e4-09c847a5f25d@suse.com>
References: <2061999c-f11b-b50d-55e4-09c847a5f25d@suse.com>
Message-ID: <59EF337E.3040809@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Larry Chen,

I think the reason is because the GLOBAL_INODE_ALLOC_SYSTEM_INODE
is just used when the device is offline, such as used in mkfs.ocfs2
and tunefs.ocfs2, it is not needed when the device is online.

Thanks
Alex

On 2017/10/24 18:39, Larry Chen wrote:
> Hi all,
> 
> Function is_global_system_inode checks whether the type is
> in the range [OCFS2_FIRST_ONLINE_SYSTEM_INODE , 
> OCFS2_LAST_GLOBAL_SYSTEM_INODE ].
> But why the range does not include GLOBAL_INODE_ALLOC_SYSTEM_INODE ??
> 
> enum {
>        ....
>         GLOBAL_INODE_ALLOC_SYSTEM_INODE,
>          SLOT_MAP_SYSTEM_INODE,
> #define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
>          HEARTBEAT_SYSTEM_INODE,
>          GLOBAL_BITMAP_SYSTEM_INODE,
>          USER_QUOTA_SYSTEM_INODE,
>          GROUP_QUOTA_SYSTEM_INODE,
> #define OCFS2_LAST_GLOBAL_SYSTEM_INODE GROUP_QUOTA_SYSTEM_INODE
>      ....
> }
> 
> Thanks
> Larry Chen
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
