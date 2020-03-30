From: George Spelvin <lkml@SDF.ORG>
Date: Mon, 30 Mar 2020 16:34:12 +0000
Subject: [Ocfs2-devel] [RFC PATCH v1 29/50] fs/ocfs2/journal: Use
 prandom_u32() and not /dev/random for timeout
In-Reply-To: <016c2bdc-68eb-245f-2292-d00d0d8e45a5@linux.alibaba.com>
References: <202003281643.02SGhIOY022599@sdf.org>
	<016c2bdc-68eb-245f-2292-d00d0d8e45a5@linux.alibaba.com>
Message-ID: <20200330163412.GA2459@SDF.ORG>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 30, 2020 at 08:09:33PM +0800, Joseph Qi wrote:
> Sorry for the late reply since I might miss this mail.

You're hardly late; I expect replies to dribble in for a week.

> On 2019/3/21 11:07, George Spelvin wrote:
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index 68ba354cf3610..939a12e57fa8b 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -1884,11 +1884,8 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
>>   */
>>  static inline unsigned long ocfs2_orphan_scan_timeout(void)
>>  {
>> -	unsigned long time;
>> -
>> -	get_random_bytes(&time, sizeof(time));
>> -	time = ORPHAN_SCAN_SCHEDULE_TIMEOUT + (time % 5000);
>> -	return msecs_to_jiffies(time);
>> +	return msecs_to_jiffies(ORPHAN_SCAN_SCHEDULE_TIMEOUT) +
>> +		prandom_u32_max(5 * HZ);
> 
> Seems better include the prandom_u32_max() into msecs_to_jiffies()?

What I'm trying to take advantage of here is constant propagation.

msecs_to_jiffies is zero cost (it's evaluated entirely at compile 
time) if its argument is a compile-time constant.  It's a function call
and a few instructions if its argument is variable.

msecs_to_jiffies(ORPHAN_SCAN_SCHEDULE_TIMEOUT + prandom_u32_max(5000))
would be forced to use the expensive version.

The compiler does't know, but *I* know, that msecs_to_jiffies() is a 
linear function, and prandom_u32_max() is a sort-of linear function.

(It's a linear function for a given PRNG starting state, so each 
individual call is linear, but multiple calls mess things up.)

Modulo a bit of rounding, we have:

msecs_to_jiffies(a + b) = msecs_to_jiffies(a) + msecs_to_jiffies(b)
msecs_to_jiffies(a) * b = msecs_to_jiffies(a * b)
prandom_u32_max(a) * b = prandom_u32_max(a * b)
prandom_u32_max(msecs_to_jiffies(a)) = msecs_to_jiffies(prandom_u32_max(a))

By doing the addition in jiffies rather than milliseconds, we get the 
cheap code.  It's not a huge big deal, but it's definitely smaller and 
faster.

Admittedly, I happen to be using HZ = 300, which requires a multiply to 
convert, and makes the resultant random numbers slightly non-uniform.  
The default HZ = 250 makes it just a divide by 4, which is pretty simple.

(When HZ = 300, you get 1..3 ms -> 1 jiffy, 4..6 ms -> 2 jiffies, and
7..10 ms -> 3 jiffies.  Multiples of 3 are 33% more likely to be chosen.)

It just seems silly and wasteful to pick a random number between 0 and 
4999 (plus 30000), only to convert it to a random number between 0 and 
1249 (plus 7500).

And if HZ = 2000 ever happens, the timeout won't be artificially limited
to integer milliseconds.
