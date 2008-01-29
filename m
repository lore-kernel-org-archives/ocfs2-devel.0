From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue Jan 29 14:22:47 2008
Subject: [Ocfs2-devel] Re: [git pull] Fix recent Ocfs2 breakage
In-Reply-To: <20080129221858.GA27902@mail.oracle.com>
References: <20080129033307.GE23506@ca-server1.us.oracle.com>
	<20080129050804.GA2285@suse.de>
	<20080129074402.GA27097@ca-server1.us.oracle.com>
	<20080129185448.GA358@suse.de>
	<20080129221858.GA27902@mail.oracle.com>
Message-ID: <20080129222239.GB27902@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@suse.de>, Mark Fasheh <mark.fasheh@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Jan 29, 2008 at 02:18:58PM -0800, Joel Becker wrote:
> 	But I'm still not understanding what you mean by "1 kobject for
> the directory".  We have one kobject for the "logmask" directory, and
> then attributes for each log type.  I don't see how that would change.

	Oh, wait, I'm an idiot.  It does look like its a kset.  If we
set the ktype to have the ops and attrs, just like we do, but use a
kobj, would that make you happier?

Joel

-- 

"The whole problem with the world is that fools and fanatics are always
 so certain of themselves, and wiser people so full of doubts."
	- Bertrand Russell

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
