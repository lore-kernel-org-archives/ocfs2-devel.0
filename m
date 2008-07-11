From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 11 Jul 2008 12:47:54 -0700
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Add extended attribute
	support v2
In-Reply-To: <1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080711194754.GA9557@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 03:27:35PM +0800, Tiger Yang wrote:
> +static inline __u32 ocfs2_xattr_name_hash(struct inode *inode,
> +					  char *prefix,
> +					  int prefix_len,
> +					  char *name,
> +					  int name_len)
> +{
> +	__u32 hash = 0;
> +	char *ptr = OCFS2_SB(inode->i_sb)->uuid_str;
> +	int i;
> +
> +	/* Get random seed from UUID */
> +	for (i = 0; i < (OCFS2_VOL_UUID_LEN * 2); i++) {
> +		hash = (hash << OCFS2_HASH_SHIFT) ^
> +		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
> +		       *ptr++;
> +	}

Ok, awesome that you've incorporated a random seed - that's much better now.

There's one small problem with your though - I think people might want to be
changing the UUID on an ocfs2 volume after a snapshot of it is taken, so
that they can mount it alonside the original. If we use the value like this,
our hashing will break when they change it.

I think maybe the easiest thing to do is compute this value at mkfs time and
store it on the superblock?
	--Mark

--
Mark Fasheh
