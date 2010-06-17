From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 17 Jun 2010 16:34:23 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <20100617192805.GA7981@mail.oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<4C197E0B.1060103@oracle.com>
	<20100617083216.GA17748@mail.oracle.com>
	<4C19DE3E.9080701@oracle.com> <4C1A35C6.1060705@oracle.com>
	<20100617192805.GA7981@mail.oracle.com>
Message-ID: <4C1AB0FF.5030802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/17/2010 12:28 PM, Joel Becker wrote:
>> No. There is no need for time ordering. Or, am I missing something?
>>
>> We delay the purge incase the file system changes its mind and wants
>> to reuse it. By delaying, we hold onto the mastery information. That's it.
>>      
> 	The comment is right there:
>
>                      /* Since resources are added to the purge list
>                       * in tail order, we can stop at the first
>                       * unpurgable resource -- anyone added after
>                       * him will have a greater last_used value */
>                      break;
>
> So we're going to break out of this loop as soon we see a later time.
> Anything you've moved to the back will be ignored until enough time
> passes that the things in front of it are candidates for purge.
> 	You could, of course, just change the 'break' to a 'continue'
> and find those, but I kind of like the short-circuit behavior.  I don't
> know how long this list is, but walking a whole bunch of "not yet"
> lockreses just to hopefully find one at the end seems silly.
> 	I think it is better to leave the busy ones at the front of the
> list and just walk past them if they can't be dealt with now.
>    

That check can remain. The fact that a lockres in the purgelist was
seen to be in use, means that another thread got to it before the
dlm_thread and that that thread is about to remove that lockres from
the purgelist shortly. As in, as soon as the two spinlocks are relinquished.
