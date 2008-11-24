From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 24 Nov 2008 14:19:40 -0800
Subject: [Ocfs2-devel] [Patch 1/3] ocfs2-tools: Resolve rpmlint	warnings
	in init scripts
In-Reply-To: <1BC14041-8A8F-40BA-821C-FA838C774CD7@suse.de>
References: <B7D332FF-F786-4DBD-862D-8ED8CCE441A9@suse.de>
	<20081118230312.GB10451@mail.oracle.com>
	<1BC14041-8A8F-40BA-821C-FA838C774CD7@suse.de>
Message-ID: <20081124221940.GD26470@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 19, 2008 at 09:02:50AM +0100, Andrew Beekhof wrote:
>
> On Nov 19, 2008, at 12:03 AM, Joel Becker wrote:
>
>> On Tue, Nov 18, 2008 at 11:18:38AM +0100, Andrew Beekhof wrote:
>>> Fix a number of LSB compliance issues reported by rpmlint regarding
>>> ocfs2 init scripts
>>>
>>> Signed-off-by: Andrew Beekhof <abeekhof@suse.de>
>>>
>>> --- upstream/vendor/common/o2cb.init.sh	2008-09-11 16:51:11.000000000
>>> +0200
>>> +++ dev/vendor/common/o2cb.init.sh	2008-10-23 14:36:49.000000000  
>>> +0200
>>> @@ -8,7 +8,8 @@
>>>  # Provides: o2cb
>>>  # Required-Start: $network
>>>  # Should-Start:
>>> -# Required-Stop:
>>> +# Should-Stop:
>>> +# Required-Stop: $null
>>
>> 	Really, rpmlint requires everyone to know some magic $null?  Who
>> the heck thought that one up?
>
> Someone with too much time on their hands
>
>> Is it portable to all distros?
>
> I'm assuming yes based on rpmlint being an external project and that its 
> vaguely consistent with $network.
> But I don't have any other distros to test on - nor the first clue on  
> how to check :-/

	Well, sles10 and rhel5 have plenty of "Required-stop" lines.
Not one of them have $null.  Checking sles11b4, some scripts have $null,
but some still have empty lines "^# Required-Stop:$"
	Actually, let's check LSB.  Latest is 3.2.  Here's the relevant
section:
http://refspecs.linux-foundation.org/LSB_3.2.0/LSB-Core-generic/LSB-Core-generic/facilname.html
It states that, "Facility names that begin with a dollar sign ('$') are
reserved system facility names. ... Conforming applications shall not
provide facilities that begin with a dollar sign."  It then lists the
reserved names: $local_fs, $network, $named, $portmap, $remote_fs,
$syslog, and $time.  Thus, $null is actually an *invalid* name.
	Ok, now let's look at sles11.  We find the definition of $null
in the manpage for insserv(8).  "The special facility $null is used to
enforce an empty dependency in case of Should-Stop and Required-Stop
otherwise insserv assumes the same dependencies as for the Start case."
So insserv(8) in sles11 is not LSB compliant.  Its optimization of the
-Stop cases (assume the same as the -Start case) requires an explicit
$null for the empty case.  LSB, conversly, interprets an empty -Stop
line as actually empty.
	rpmlint is wrong here, as it is tracking a SuSE-only behavior.
At least, I can't find a RHEL system that behaves different from LSB.
	Fortunately, the solution is easy.  Our Required-Stop should be
$network, not empty.  We want the network still up when we stop o2cb.
This is valid on both an LSB-compliant system and sles11.

Joel

-- 

"Time is an illusion, lunchtime doubly so."
        -Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
