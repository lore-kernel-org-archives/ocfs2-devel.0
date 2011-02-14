From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 13 Feb 2011 23:25:04 -0800
Subject: [Ocfs2-devel] [PATCH] Zero from EOF instead of next block
In-Reply-To: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
References: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
Message-ID: <20110214072503.GA8413@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 14, 2011 at 12:21:41AM -0600, Goldwyn Rodrigues wrote:
> ocfs2_zero_extend() extends the file from the next page offset
> rather from the current file size. zero_extend_page() should
> call ocfs2_zero_partial_cluster() to set zero rest of the cluster
> when the file size is within the page boundaries.

	We just went over this.  It is intentional that we start from
the next block.  Linux code always assumes that the block containing
i_size is properly zeroed to its end.  Our last set of fixes for this
made sure we were doing that correctly.  Or so I thought.
	Your patch description looks like you are worried that we don't
zero from EOF to End-Of-Block.  Have you proof we've failed that again?
Or are you worried that we don't zero from EOB to End-Of-Cluster?  We
used to zero to EOC, but we now know that to be a mistake.

Joel

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

			http://www.jlbec.org/
			jlbec at evilplan.org
