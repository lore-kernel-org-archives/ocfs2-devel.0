From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 31 Dec 2010 14:39:52 -0800
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
 mlog(0).
In-Reply-To: <4D1DF2A3.9090106@tao.ma>
References: <4D12F7E7.1090204@tao.ma> <20101231125217.GC21179@mail.oracle.com>
	<4D1DF2A3.9090106@tao.ma>
Message-ID: <20101231223951.GC20521@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 31, 2010 at 11:11:31PM +0800, Tao Ma wrote:
> On 12/31/2010 08:52 PM, Joel Becker wrote:
> > 	Overall this seems pretty straightforward.  There wasn't a lot
> > of editing of masklog entries; we still have a million tracepoints.  I
> > wonder how much memory that will use.  Have you checked the space usage
> > of all the sysfs files for all of our tracepoints?
> Sorry, I don't know how to check the space usage of these files. any tips?

	Just count the number of files and directories added to sysfs.
I believe the files disappear when not open, but the directories
I think have inode and dentry structures around permanently..

> > 	Well, one generic comment.  It seems a lot of our log messages
> > have gone from "ocfs2_foo(): Change blah 0x%p to new_blah 0x%p" to
> > "ocfs2_foo(): %p %p".  I wonder if that is going to be hard to read.
> Yeah, I used to think of adding all these descriptive strings to trace 
> buffers, but finally I gave up. The reason is that no matter how we 
> print the message in the trace buffer, we have to go to read the codes 
> and with the codes, everything should be clear enough. ;)

	Ok, we'll give it a shot.

Joel

-- 

"The opposite of a correct statement is a false statement. The
 opposite of a profound truth may well be another profound truth."
         - Niels Bohr 

			http://www.jlbec.org/
			jlbec at evilplan.org
