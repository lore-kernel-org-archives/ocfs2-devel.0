From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 4 Mar 2009 12:36:37 -0800
Subject: [Ocfs2-devel] [Ocfs2-tools-devel] Patch to Pacemaker hooks
	in	ocfs2_controld
In-Reply-To: <26ef5e70903041231o31854e8ai5e2da64f2debcea9@mail.gmail.com>
References: <D8579235-5640-43E5-9B8D-F9B469021ABE@gmail.com>
	<20090304193011.GB27565@mail.oracle.com>
	<26ef5e70903041231o31854e8ai5e2da64f2debcea9@mail.gmail.com>
Message-ID: <20090304203637.GA19856@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 04, 2009 at 09:31:17PM +0100, Andrew Beekhof wrote:
> > ? ? ? ?I don't like log_printf(). ?First because log_error() already
> > exists for LOG_ERR printing, second because you strip out all the useful
> > log_debug() calls, but most of all because your log_printf() doesn't add
> > to the internal daemon ring buffer. ?So debugfs.ocfs2 -R 'controld dump'
> > doesn't show those messages.
> > ? ? ? ?Is there a reason log_error() didn't work for you?
> 
> Re: log_error, I think I was just trying to be consistent with the
> other calls I saw.
> But I was working with the dlm_controld hooks at the same time so I
> may have gotten my wires crossed.

	Yeah, dave's changed his scheme some, and I haven't caught up.
The big deal is that it skips the dump buffer.

> Re: log_debug, I got complaints about the logging being too noisy.
> Plus there's not a lot of logging in the rest of ocfs2_controld, so in
> many ways its more consistent ;-)
> 
> Would you be interested in a patch that adds more logging to the rest
> of ocfs2_controld?
> The lack of logging, particularly in some of the error paths, has been
> killing us.

	I'm confused.  You took out useful logging messages because
there was too much, so you want to add more?
	Overall, I'm very happy with the idea of more logging, at least
log_debug() logging - we shouldn't spam syslog with crap.

Joel

-- 

"Drake!  We're LEAVING!"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
