From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 30 Apr 2009 15:43:32 -0700
Subject: [Ocfs2-devel] orphan cleanup
In-Reply-To: <49F9FA82.3020201@oracle.com>
References: <20090430185346.GE2762@mail.oracle.com>
	<49F9FA82.3020201@oracle.com>
Message-ID: <49FA2994.2080803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hmm, even if we queue the orphan recovery, inode may not get cleaned if 
the inode is still around on some node right? The node where the inode 
is still cached will vote "no" again?

Sunil Mushran wrote:
> Joel Becker wrote:
>> Srini,
>>     Ok, you can go ahead and cook up the background orphan cleaner.
>> Now, we can do this in a workqueue, a thread, or a timer.  I don't see
>> why a timer doesn't work.  When the timer fires, you do this:
>>
>> 1. Take EX on a new orphan_scan lock.
>> 2. check the LVB for the last scan time.  If it's less than the scan
>>    timeout, reset the timer for (timeout - last scan), drop the EX, and
>>    exit.
>
> We should add a random value to the timeout. Else the master will end up
> "winning" the task every time.
>
>> 3. Call ocfs2_queue_recovery_completion() for all slots with NULL, NULL,
>>    NULL on the non-orphan-dir arguments.  This sets up the orphan
>>    recovery.
>> 4. Update the LVB with the current scan time.
>> 5. Drop the EX to an NL.
>> 6. Reset the timer for the scan timeout.
>>
>>     Points about this scheme:
>>
>> - Doesn't need a process.
>> - Don't need to change the locking protocol version, as older versions
>>   just ignore this problem.
>> - Ensures only one node runs the scan each timeout period.
>> - Uses our existing orphan recovery code unchanged.
>> - We don't need to keep a PR on the orphan scan lock.  It's just extra
>>   network traffic and downconvert processing we don't care about.
>>   Better to wake up once when our timeout fires than to wake up every
>>   time another node goes to make a scan.
>> - I realize that I've updated the scan time at the queue of the scan,
>>   not at the completion.  It doesn't really make much of a difference
>>   with many-minute scan periods, and it is a lot simpler than trying to
>>   add code to wait on all the orphans.
>>
>> Joel
>
> Looks good.
