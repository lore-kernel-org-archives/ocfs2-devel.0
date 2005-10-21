From: Andrew Beekhof <abeekhof@suse.de>
Date: Fri Oct 21 04:05:34 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051020154519.GO11726@marowsky-bree.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
	<20051020150341.GC11488@ca-server1.us.oracle.com>
	<20051020152606.GB16745@redhat.com>
	<20051020154244.GD11488@ca-server1.us.oracle.com>
	<20051020154519.GO11726@marowsky-bree.de>
Message-ID: <9FBDF3A9-27F7-4F4F-BE47-47174A31A586@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Oct 20, 2005, at 5:45 PM, Lars Marowsky-Bree wrote:

> On 2005-10-20T08:42:44, Joel Becker <Joel.Becker@oracle.com> wrote:
>
>
>>     Hehe, when you said "mount process..." in your description, I
>> assumed mount.gfs :-)  You might want to rip off the
>> generic-mount-option-parsing code from mount.ocfs2 (which we  
>> ripped off
>> from mount.smb).
>>
>
> So that settles how to resolve this. How boring! A solved problem. ;-)
>

for future reference, in the context of hb2 the callout will have to  
either:
- create a placement constraint to put the new clone on the correct node
- increase the number of clones
- somehow figure out if the new clone would ever be started  
(otherwise it may block forever)
- wait for the new clone to be started

or, do nothing (if invoked by hb2 directly)

--
Andrew Beekhof

"If it weren't for my horse, I wouldn't have spent that year in  
college" - Unknown, courtesy of Lewis Black
