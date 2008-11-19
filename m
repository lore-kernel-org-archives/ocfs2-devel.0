From: Andrew Beekhof <abeekhof@suse.de>
Date: Wed, 19 Nov 2008 09:02:50 +0100
Subject: [Ocfs2-devel] [Patch 1/3] ocfs2-tools: Resolve rpmlint warnings
	in init scripts
In-Reply-To: <20081118230312.GB10451@mail.oracle.com>
References: <B7D332FF-F786-4DBD-862D-8ED8CCE441A9@suse.de>
	<20081118230312.GB10451@mail.oracle.com>
Message-ID: <1BC14041-8A8F-40BA-821C-FA838C774CD7@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Nov 19, 2008, at 12:03 AM, Joel Becker wrote:

> On Tue, Nov 18, 2008 at 11:18:38AM +0100, Andrew Beekhof wrote:
>> Fix a number of LSB compliance issues reported by rpmlint regarding
>> ocfs2 init scripts
>>
>> Signed-off-by: Andrew Beekhof <abeekhof@suse.de>
>>
>> --- upstream/vendor/common/o2cb.init.sh	2008-09-11 16:51:11.000000000
>> +0200
>> +++ dev/vendor/common/o2cb.init.sh	2008-10-23 14:36:49.000000000  
>> +0200
>> @@ -8,7 +8,8 @@
>>  # Provides: o2cb
>>  # Required-Start: $network
>>  # Should-Start:
>> -# Required-Stop:
>> +# Should-Stop:
>> +# Required-Stop: $null
>
> 	Really, rpmlint requires everyone to know some magic $null?  Who
> the heck thought that one up?

Someone with too much time on their hands

> Is it portable to all distros?

I'm assuming yes based on rpmlint being an external project and that  
its vaguely consistent with $network.
But I don't have any other distros to test on - nor the first clue on  
how to check :-/
