From: Tao Ma <tm@tao.ma>
Date: Tue, 04 Jan 2011 17:06:53 +0800
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
 mlog(0).
In-Reply-To: <20101231223951.GC20521@mail.oracle.com>
References: <4D12F7E7.1090204@tao.ma> <20101231125217.GC21179@mail.oracle.com>
	<4D1DF2A3.9090106@tao.ma> <20101231223951.GC20521@mail.oracle.com>
Message-ID: <4D22E32D.40406@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/01/2011 06:39 AM, Joel Becker wrote:
> On Fri, Dec 31, 2010 at 11:11:31PM +0800, Tao Ma wrote:
>> On 12/31/2010 08:52 PM, Joel Becker wrote:
>>> 	Overall this seems pretty straightforward.  There wasn't a lot
>>> of editing of masklog entries; we still have a million tracepoints.  I
>>> wonder how much memory that will use.  Have you checked the space usage
>>> of all the sysfs files for all of our tracepoints?
>> Sorry, I don't know how to check the space usage of these files. any tips?
>
> 	Just count the number of files and directories added to sysfs.
> I believe the files disappear when not open, but the directories
> I think have inode and dentry structures around permanently..
OK, so
#find /sys/kernel/debug/tracing/events/ocfs2 -type d|wc -l
give me 319. Every trace event dir has 4 members(enable,filter,format 
and id). So it contains about 1600(dir+files).

>
>>> 	Well, one generic comment.  It seems a lot of our log messages
>>> have gone from "ocfs2_foo(): Change blah 0x%p to new_blah 0x%p" to
>>> "ocfs2_foo(): %p %p".  I wonder if that is going to be hard to read.
>> Yeah, I used to think of adding all these descriptive strings to trace
>> buffers, but finally I gave up. The reason is that no matter how we
>> print the message in the trace buffer, we have to go to read the codes
>> and with the codes, everything should be clear enough. ;)
>
> 	Ok, we'll give it a shot.
I have rebased my tree with Linus' latest tree and integrated all the 
comments Christoph and you have prompted.

View:
http://repo.or.cz/w/taoma-kernel.git/shortlog/refs/heads/new_mlog_replace

and pull from
git://repo.or.cz/taoma-kernel.git new_mlog_replace

Please consider merging it. Thanks.

Regards,
Tao
