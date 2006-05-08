From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon, 08 May 2006 10:50:10 -0700
Subject: [Ocfs2-devel] Please help me in getting OCFS2 design doc.
In-Reply-To: <c04850370605080623r3867621bk8f036c856691e9e7@mail.gmail.com>
References: <c04850370605020715x5b99c4c1s9f168ab0acf5840a@mail.gmail.com>	<445792A9.4030508@oracle.com>	<c04850370605030418p70bb54b6j2c96f7aa0b3ef6c8@mail.gmail.com>	<445941F6.8050205@oracle.com>
	<c04850370605080623r3867621bk8f036c856691e9e7@mail.gmail.com>
Message-ID: <445F84D2.908@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sum Sha wrote:
> Thanks again for providing this information. I thought, we create
> volumes with ASM and then format those volumes with OCFS2 and then
> mount them. I probably missed it ;-)
>
> One more thing which I'd be interested to discuss is "heartbeat
> mechanism" and "self-fencing" behaviour of OCFS2.
>
> I have read that
> "An active node is deemed dead if it does not update its timestamp for
> O2CB_HEARTBEAT_THRESHOLD (default=7) loops"
>                                           and
> "A node self-fences if it fails to update its timestamp for
> ((O2CB_HEARTBEAT_THRESHOLD - 1) * 2) secs. The [o2hb-xx] kernel
> thread, after every timestamp write, sets a timer to panic the system
> after that duration. If the next timestamp is written within that
> duration, as it should, it first cancels that timer before setting up
> a new one"
>
> Here, the first case seems to be dependent on the second one, isn't
> it? If a node is not able to see other nodes' timestamp within
> (O2CB_HEARTBEAT_THRESHOLD * 2) time, then it assumes one of the
> following things:
>
> 1. The other node could not put timestamp within
> (O2CB_HEARTBEAT_THRESHOLD - 1) * 2 time and paniced itself.
>                                OR
> 2. The other node is actually dead and we give extra 2 seconds to
> detect that. Are we giving these extra 2 seconds to [hb-xx] kernel
> thread for detecting this scenario?
>
>   
I am not sure what the difference is between the two. The other nodes don't
care what the reason is for the node not to be able to update the hb. 
All they
care is whether it was updated or not. Also, the extra 2 secs should be 
viewed
from the other side... the node panics itself 2 secs before the other 
will deem
it dead and kick it off the cluster.
