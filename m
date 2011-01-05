From: Tao Ma <tm@tao.ma>
Date: Wed, 05 Jan 2011 10:25:17 +0800
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
 mlog(0).
In-Reply-To: <20110104221517.GB30671@mail.oracle.com>
References: <4D12F7E7.1090204@tao.ma> <20101231125217.GC21179@mail.oracle.com>
	<4D1DF2A3.9090106@tao.ma> <20101231223951.GC20521@mail.oracle.com>
	<4D22E32D.40406@tao.ma> <20110104221517.GB30671@mail.oracle.com>
Message-ID: <4D23D68D.7040809@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/05/2011 06:15 AM, Joel Becker wrote:
> On Tue, Jan 04, 2011 at 05:06:53PM +0800, Tao Ma wrote:
>> On 01/01/2011 06:39 AM, Joel Becker wrote:
>>> On Fri, Dec 31, 2010 at 11:11:31PM +0800, Tao Ma wrote:
>>>> On 12/31/2010 08:52 PM, Joel Becker wrote:
>>>>> 	Overall this seems pretty straightforward.  There wasn't a lot
>>>>> of editing of masklog entries; we still have a million tracepoints.  I
>>>>> wonder how much memory that will use.  Have you checked the space usage
>>>>> of all the sysfs files for all of our tracepoints?
>>>> Sorry, I don't know how to check the space usage of these files. any tips?
>>>
>>> 	Just count the number of files and directories added to sysfs.
>>> I believe the files disappear when not open, but the directories
>>> I think have inode and dentry structures around permanently..
>> OK, so
>> #find /sys/kernel/debug/tracing/events/ocfs2 -type d|wc -l
>> give me 319. Every trace event dir has 4
>> members(enable,filter,format and id). So it contains about
>> 1600(dir+files).
>
> 	I think what matters to count is dirs, because files disappear
> when you're not using them.
> 	If you have 319 trace event directories, that's 319 inodes.  On
> my x86, a vanilla struct inode is 360 bytes and a dentry is 136 bytes.
> That's 154K always in RAM for these knobs.  I gotta say that I'm not too
> worried about 154K.  On x86_64 (ca-build24) this grows to 241K.  I
> imagine it will double when cluster and dlm are moved to similar trace
> events.
> 	Are we OK with 300K on x86 and 500K on x86_64 always used up by
> these tracing entries?
yeah, it isn't much I guess.

And for ext4, yes, it has a small number because they have a very 
limited debug tracing than us, maybe because they evolved from 
ext2->ext3->ext4. So the code base is really stable now. And I guess we 
can remove some of the trace events if we feel that the code is stable 
enough. ;)

Regards,
Tao
