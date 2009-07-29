From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Jul 2009 11:57:21 +0200
Subject: [Ocfs2-devel] [PATCH 3/8] Implement quota functions to libocfs2
In-Reply-To: <20090728225244.GA20595@mail.oracle.com>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-4-git-send-email-jack@suse.cz>
	<4A6EAEF2.10705@oracle.com> <20090728084055.GB5880@duck.suse.cz>
	<4A6EBA4A.1030107@oracle.com> <20090728100829.GA14484@duck.suse.cz>
	<20090728225244.GA20595@mail.oracle.com>
Message-ID: <20090729095721.GB19209@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 28-07-09 15:52:45, Joel Becker wrote:
> On Tue, Jul 28, 2009 at 12:08:29PM +0200, Jan Kara wrote:
> > +/* Read given block */
> > +static errcode_t read_blk(ocfs2_filesys *fs, int type, uint blk, char *buf)
> 
> 	You're sure quota files will never be larger than a uint?  Also,
> we tend to do 'unsigned int', not 'uint'.
  Well, the disk format is designed only for 32-bit uids and gids (which is
consistent with the rest of OCFS2). For 2^32 users tracked in the quota file,
it is going to have around 2^29 blocks so yes, unsigned int should be safe
:)
  I'll substitute uint with unsigned int... although it's horribly long for
such a useful type ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
