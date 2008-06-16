From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 16 Jun 2008 15:18:45 +0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended
 attributes	support. v1
In-Reply-To: <20080613032230.GW28100@wotan.suse.de>
References: <484792D1.3080802@oracle.com>	<1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
	<20080613032230.GW28100@wotan.suse.de>
Message-ID: <485613D5.8090706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
>> +
>> +#define OCFS2_XATTR_PAD_BITS	2
>> +#define OCFS2_XATTR_PAD		4
>> +#define OCFS2_XATTR_ROUND	(OCFS2_XATTR_PAD-1)
>> +#define OCFS2_XATTR_SIZE(size)	(((size) + OCFS2_XATTR_ROUND) & \
>> +				~OCFS2_XATTR_ROUND)
>> +#define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
>> +#define OCFS2_XATTR_INLINE_SIZE	80
>> +#define OCFS2_NAME_HASH_SHIFT	5
>> +#define OCFS2_VALUE_HASH_SHIFT	16
> 
> Some of these should be defined in the patch where they're actually used.
I wonder whether we should put the below lines into ocfs2_fs.h(combined 
with my previous xattr header patch)?
#define OCFS2_XATTR_PAD_BITS	2
#define OCFS2_XATTR_PAD		4
#define OCFS2_XATTR_ROUND	(OCFS2_XATTR_PAD-1)
#define OCFS2_XATTR_SIZE(size)	(((size) + OCFS2_XATTR_ROUND) & \
				~OCFS2_XATTR_ROUND)

ocfs2-tools also need this when fsck try to find the large xattr value. 
So if we put them in ocfs2_fs.h, we can keep both tools and kernel src 
synchronized easily.

Regards,
Tao
