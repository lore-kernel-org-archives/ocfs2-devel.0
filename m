From: Coly Li <coly.li@suse.de>
Date: Wed, 08 Jul 2009 02:35:00 +0800
Subject: [Ocfs2-devel] lvb length issue [was Re: [ocfs2-tools-devel]
 question of ocfs2_controld (Jun 27)]
In-Reply-To: <4A5384B4.1040109@oracle.com>
References: <4A451AB5.9070908@suse.de>
	<20090626193436.GC4478@mail.oracle.com>	<4A45257C.6040704@suse.de>
	<20090629080023.GB8373@mail.oracle.com>	<4A51ED7F.2040105@suse.de>
	<20090707160113.GA9140@redhat.com> <4A5384B4.1040109@oracle.com>
Message-ID: <4A539554.7050606@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> David Teigland wrote:
>> Yes, the kernel dlm api allows a variable lvb size, but the user dlm
>> api fixes
>> it at 32.
>>
>> Do you need to actually use a 64 byte lvb from userspace?  Or do you
>> just need
>> to create the locksapce with a 64 byte lvb?  We could add a flag to work
>> around the later fairly easily.  Changing the dlm user/kernel
>> interface to
>> copy variable size lvb's would take some significant work.
> 
> I guess the problem here is that Coly is attempting to run mkfs on a volume
> that is mounted on another node. mkfs.ocfs2 joins the lockspace to
> ensure it
> is not in use across the cluster, before cleaning out the superblock. If
> it is
> mounted, the lockspace would have been created by the fs... meaning
> 64-byte lvb.
> 
> Coly, is this correct?

Yes, this is what I mean.



-- 
Coly Li
SuSE Labs
