From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Jan 28 23:44:50 2008
Subject: [Ocfs2-devel] Re: [git pull] Fix recent Ocfs2 breakage
In-Reply-To: <20080129050804.GA2285@suse.de>
References: <20080129033307.GE23506@ca-server1.us.oracle.com>
	<20080129050804.GA2285@suse.de>
Message-ID: <20080129074402.GA27097@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@suse.de>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jan 28, 2008 at 09:08:04PM -0800, Greg KH wrote:
> And please please please please document stuff like this, and all of the
> different files you have in this subdirectory in Documentation/ABI/ so

	Huh, I didn't know Documentation/ABI existed.  That would
certainly help in the future.

> those of us who are trying to figure out the code (and there's still
> parts of the kobject usage I'm pretty sure is not correct) can have a

	ocfs2 kobject usage, or other folks'?  If there's anything in
the ocfs2 usage that you are unsure of, feel free to ask!

Joel

-- 

"Also, all of life's big problems include the words 'indictment' or
	'inoperable.' Everything else is small stuff."
	- Alton Brown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
