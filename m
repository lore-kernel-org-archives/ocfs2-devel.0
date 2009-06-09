From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 09 Jun 2009 14:12:00 -0700
Subject: [Ocfs2-devel] [SUGGESSTION 1/1] OCFS2: runtime tunable network
 idle timeout
In-Reply-To: <4A2DD85E.7060505@oracle.com>
References: <200906080538.n585cmss000404@acsinet15.oracle.com>
	<4A2D51EF.3030606@oracle.com> <4A2DD85E.7060505@oracle.com>
Message-ID: <4A2ED020.1010601@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is the same dlm hash too small in 1.2. It has been addressed in 1.4.

Suggest client upgrade to 1.4.

Wengang Wang wrote:
> Sunil,
>
> Sunil Mushran wrote:
>> wengang wang wrote:
>>> backgroud:
>>>     there is a network idle timeout regarding which a node is 
>>> considered dead or network partition occures.
>>> problem:
>>>     for some product environment, there is a special time during a 
>>> day. in this special time, a backup work is happening over private 
>>> network. at the time that the backup is going on, there is very very 
>>> high load on network. this can lead to ocfs2 network idle timeout 
>>> and when it can't connect back in time, some nodes have to be fensed 
>>> out the cluster domain which is not really what we want.
>>
>> Bug#? SR? Have we ruled out a bug in our code? The last time I saw 
>> one of these
>> we determined it was because of a bug.
>
> one of the bugs is:
> https://bug.oraclecorp.com/pls/bug/webbug_print.show?c_rptno=8443612
>
> oh, sorry that I didn't notice it could be caused by a bug. will get 
> tcpdumps to do more analyse on it..
>
>>
>>>     there is a configuration O2CB_IDLE_TIMEOUT_MS by which we can 
>>> set the timeout value. but looks it takes effect on when o2cb 
>>> service is restarted, so it's not possible to change it in the 
>>> already running system.
>>>
>>> suggestion:
>>>     if we can modify the timeout value at runtime, it's better. we 
>>> can add a proc file under /proc/fs/ocfs2_nodemanager, for example, 
>>> idle_timeout, so that a userspace application(such as debugfs.ocfs2) 
>>> can read/write the timeout value. before the customer run the 
>>> backup, set the value to a big value(or to no limit) and set it back 
>>> when backup finished.
>>>     contents in /proc/fs/ocfs2_nodemanager/idle_timeout is the 
>>> timeout value in MS. 0 means no limit.
>>>
>>> if it's good, I'm glad to do it.
>>
>> One cannot just set this value on one node. It would have to be set 
>> atomically
>> on all nodes.
>>
>
> Yes, I know that.
>
>> While that can still be done, my issue is as to why one cannot set 
>> that timeout
>> up front. Asking clients to "set" timeout dynamically before certain 
>> fs operations
>> is not at all friendly. Especially when the user has no idea as what 
>> workload a
>> certain operation entails.
>
> if the timeout is set as a too large value, I think it will cause 
> slower response when a timeout happens(a true node death or network 
> partition) for a normal network load. for a production environment, 
> it's not good.
>
> and yes it's difficult for clients to determine a high network load 
> unless they has a very cool administrator -- that's a problem.
>
> Ok, then we put it away now and put it up when we know clearly about 
> the problem.
>
> thanks
> wengang.
>
