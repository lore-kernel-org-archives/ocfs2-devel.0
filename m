From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Jun 2010 12:28:06 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <4C1A35C6.1060705@oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<4C197E0B.1060103@oracle.com>
	<20100617083216.GA17748@mail.oracle.com>
	<4C19DE3E.9080701@oracle.com> <4C1A35C6.1060705@oracle.com>
Message-ID: <20100617192805.GA7981@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 17, 2010 at 07:48:38AM -0700, Sunil Mushran wrote:
> On 06/17/2010 01:35 AM, Srinivas Eeda wrote:
> >On 6/17/2010 1:32 AM, Joel Becker wrote:
> >>	As far as I can tell from reading the code, the time_after()
> >>check is because they are time ordered.  Wouldn't moving it to the end
> >>violate that?
> >right. that's why I didn't want to move used lockres to tail :)
> 
> 
> No. There is no need for time ordering. Or, am I missing something?
> 
> We delay the purge incase the file system changes its mind and wants
> to reuse it. By delaying, we hold onto the mastery information. That's it.

	The comment is right there:

                    /* Since resources are added to the purge list
                     * in tail order, we can stop at the first
                     * unpurgable resource -- anyone added after
                     * him will have a greater last_used value */
                    break;

So we're going to break out of this loop as soon we see a later time.
Anything you've moved to the back will be ignored until enough time
passes that the things in front of it are candidates for purge.
	You could, of course, just change the 'break' to a 'continue'
and find those, but I kind of like the short-circuit behavior.  I don't
know how long this list is, but walking a whole bunch of "not yet"
lockreses just to hopefully find one at the end seems silly.
	I think it is better to leave the busy ones at the front of the
list and just walk past them if they can't be dealt with now.

Joel

-- 

Life's Little Instruction Book #157 

	"Take time to smell the roses."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
