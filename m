From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 28 Jul 2009 15:52:45 -0700
Subject: [Ocfs2-devel] [PATCH 3/8] Implement quota functions to libocfs2
In-Reply-To: <20090728100829.GA14484@duck.suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-4-git-send-email-jack@suse.cz>
	<4A6EAEF2.10705@oracle.com> <20090728084055.GB5880@duck.suse.cz>
	<4A6EBA4A.1030107@oracle.com> <20090728100829.GA14484@duck.suse.cz>
Message-ID: <20090728225244.GA20595@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 28, 2009 at 12:08:29PM +0200, Jan Kara wrote:
> +/* Read given block */
> +static errcode_t read_blk(ocfs2_filesys *fs, int type, uint blk, char *buf)

	You're sure quota files will never be larger than a uint?  Also,
we tend to do 'unsigned int', not 'uint'.

Joel

-- 

"When I am working on a problem I never think about beauty. I
 only think about how to solve the problem. But when I have finished, if
 the solution is not beautiful, I know it is wrong."
         - Buckminster Fuller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
