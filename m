From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 29 Jul 2010 11:08:45 +0800
Subject: [Ocfs2-devel] Global heartbeat - drop#1
In-Reply-To: <4C505D7C.9020209@oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<20100728144533.GA3128@laptop.jp.oracle.com>
	<4C505D7C.9020209@oracle.com>
Message-ID: <20100729030845.GA2591@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-07-28 09:40, Sunil Mushran wrote:
> If the io stack on a non-hb device fails, the apps will start getting
> EIOs. Possibly leading to application death. But the system will stay
> up.

Yes, that is the result.
> 
> The dlm domain should remain available.

Yes the dlm its self remains available.
> 
> One case I can see happening is if the journal op fail (say commit
> triggered by downconvert). In that case, the fs will fence the box.
> 
> Do you have a specific example?
I have no good example, but just thinking about this case:

A two nodes HA cluster, node A is active and node B is backup.
If the non-hb device fails on node A, since no failover will happen in this
case, the app will keep getting the EIOs on the active node. User maybe
complain with that? With lhb, node A will be restarted and failover will happen
so that user app won't keep getting EIOs.

Or all nodes are active nodes, but they all get EIOs since no fence in this case.

It is just a question, not a big problem for the helpful ghb :)

regards,
wengang.

> On 07/28/2010 07:45 AM, Wengang Wang wrote:
> >Hi Sunil,
> >
> >The global heartbeat also introduce a difference comparing with local heart.
> >With the ghb, what if the non-heartbeat ocfs2 volume(s) fail(s)? Say some lower
> >layer(raid/disk-driver) become unhappy to work anymore. In case, no failover
> >since no self-fence I think. So it could cause the domain in question
> >unavailable(finally), isn't it? With the original lhb scheme, no such problem.
> >Is there a solution?
> >
