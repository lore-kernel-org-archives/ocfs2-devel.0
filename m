From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 29 Jul 2010 10:28:09 -0700
Subject: [Ocfs2-devel] Global heartbeat - drop#1
In-Reply-To: <20100729030845.GA2591@laptop.jp.oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<20100728144533.GA3128@laptop.jp.oracle.com>
	<4C505D7C.9020209@oracle.com>
	<20100729030845.GA2591@laptop.jp.oracle.com>
Message-ID: <4C51BA29.5080506@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/28/2010 08:08 PM, Wengang Wang wrote:
>
>> One case I can see happening is if the journal op fail (say commit
>> triggered by downconvert). In that case, the fs will fence the box.
>>
>> Do you have a specific example?
>>      
> I have no good example, but just thinking about this case:
>
> A two nodes HA cluster, node A is active and node B is backup.
> If the non-hb device fails on node A, since no failover will happen in this
> case, the app will keep getting the EIOs on the active node. User maybe
> complain with that? With lhb, node A will be restarted and failover will happen
> so that user app won't keep getting EIOs.
>
> Or all nodes are active nodes, but they all get EIOs since no fence in this case.
>
> It is just a question, not a big problem for the helpful ghb :)
>
>    

o2hb is meant only for ocfs2. If one wants app failover, then one
can use clusterware or rgmanager or pacemaker. Or one can hand
craft app failover on ocfs2 using dlmfs. I know users that are doing so.
