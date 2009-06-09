From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 9 Jun 2009 11:01:02 -0700
Subject: [Ocfs2-devel] [PATCH] OCFS2: fdatasync should skip unimportant
	metadata	writeout
In-Reply-To: <6.0.0.20.2.20090609154314.0729f488@172.19.0.2>
References: <6.0.0.20.2.20090609154314.0729f488@172.19.0.2>
Message-ID: <20090609180102.GA30966@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 09, 2009 at 04:47:45PM +0900, Hisashi Hifumi wrote:
> In ocfs2, fdatasync and fsync are identical.
> I think fdatasync should skip committing transaction when 
> inode->i_state is set just I_DIRTY_SYNC and this indicates
> only atime or/and mtime updates.
> Following patch improves fdatasync throughput.

	Nicely done, thanks.  This is now in the ocfs2 git tree.

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
