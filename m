From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 15 Jan 2009 14:21:20 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: return f_fsid info in
	ocfs2_statfs()
In-Reply-To: <496F95A8.3030404@oracle.com>
References: <496F8957.3000201@suse.de> <496F8DBB.7080706@oracle.com>
	<496F931A.2040401@suse.de> <496F95A8.3030404@oracle.com>
Message-ID: <20090115222120.GB17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 15, 2009 at 11:59:36AM -0800, Sunil Mushran wrote:
> It's worse. As far as I can see, the s_uuid_hash is never populated.
> So we have two problems. The second issue is urgent as we are
> using it in xattr.

Well, mkfs.ocfs2/tunefs.ocfs2 is supposed to populate it s_uuid_hash based
on the *original* uuid of the file system. We don't dynamically calculate it
because uuid might change due to a clone operation, which would then break
the hashing of that particular file system.

Since s_uuid_hash is feature specific, I think perhaps we should just use
some part of the uuid, which is always populated. For this, I think we could
do the same as the o2cb dlm key (which has to also be pretty unique) -
crc32_le(uuid).
	--Mark

--
Mark Fasheh
