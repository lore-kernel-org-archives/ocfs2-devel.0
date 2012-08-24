From: Tao Ma <tm@tao.ma>
Date: Fri, 24 Aug 2012 09:42:17 +0800
Subject: [Ocfs2-devel] RFC: OCFS2 heartbeat improvements
In-Reply-To: <CAEeiSHUNXAHcRko4zYePSy=Qm3xG0haVd0Puj3oWXS5Mq8K7ZQ@mail.gmail.com>
References: <5034EA17.107@oracle.com> <5035A719.1000707@tao.ma>
	<CAEeiSHUNXAHcRko4zYePSy=Qm3xG0haVd0Puj3oWXS5Mq8K7ZQ@mail.gmail.com>
Message-ID: <5036DBF9.5030500@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 08/24/2012 01:33 AM, Sunil Mushran wrote:
> On Wed, Aug 22, 2012 at 8:44 PM, Tao Ma <tm at tao.ma <mailto:tm@tao.ma>>
> wrote:
> 
>     I guess the final solution will be WRITE_FUA, and I see btrfs uses it to
>     write out the superblock. It will be handled differently by the
>     underlying block layer so that it will not be in the elevator queue. It
>     should work but I am not sure whether we need to be so aggressive. Maybe
>     some test will show.
> 
> 
> FUA is an overkill for the heartbeat data because we don't care if that data
> hits the platter or not. It can stay in the device's volatile cache.
> Infact, staying
> in the cache, and not hitting the platter, is better.
yes, but it has the benefit that the elevator will not try to add it in
the queue and avoid any possible latency from the elevator. And my
another concern is that if ocfs2 has some high-end shared storage, it
should optimize the FUA command to be very fast and even within its
cache if the storage can survive the power outage. Having said that, it
may hurt if the backend storage doesn't implement FUA fast enough. So
maybe we can add a new parameter so that the user can decide what type
of heartbeat write he/she needs.

Thanks
Tao
