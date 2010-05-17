From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 17 May 2010 12:17:46 -0700
Subject: [Ocfs2-devel] Quota locking fixes for OCFS2
In-Reply-To: <20100517161801.GA3364@quack.suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
	<20100513235114.GE13692@mail.oracle.com>
	<20100514080803.GB3488@quack.suse.cz>
	<20100514193622.GC29764@mail.oracle.com>
	<20100517161801.GA3364@quack.suse.cz>
Message-ID: <20100517191746.GA22775@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 17, 2010 at 06:18:01PM +0200, Jan Kara wrote:
>   OK, will do. In the mean time I have found one more possible deadlock
> which should be fixed by the attached patch so I'll add it to the series
> if you won't object.

	One question: is it possible for additional work to be added
between the time we call the cancel and the time we take the
dqonoff_mutex?  If it is not possible, ack on the patch and put it in
the series.

Joel

-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd at loiosh.kei.com)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
