From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 28 Jan 2010 21:00:15 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <4B609D5E.5080404@oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
	<20100120045531.GA3794@laptop.oracle.com>
	<4B5749CF.6070004@oracle.com>
	<20100127181429.GA4635@laptop.oracle.com>
	<4B609D5E.5080404@oracle.com>
Message-ID: <20100128130014.GA4083@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil,

On 10-01-27 12:09, Sunil Mushran wrote:
> Wengang Wang wrote:
>> I think the timer is not a very good idea. Canceling an ocfs2 cluster
>> lock is not complex though it needs lines of code changes. By your 
>> word, I felt you are meaning that the timer is a separated thing
>> from ocfs2_cluster_lock(). If so, we have to ensure the ocfs2_cluster_lock()
>> is really issued before the timer acts. Though here 30s is good that but are
>> we sure that it must be enough at any case? --I think we aren't.
>> Making sure cluster lock is issued before the timer acts, I guess we
>> need more code change and I think that is not worthy --it introduces bugs
>> and it's only for freeze/thaw, not a common demand.
>>
>> So to avoid very long time waiting of a mount when cluster is frozen, I
>> want it make tries of no-queue cluster lock. And so does it when acquiring EX.
>
> noqueue will not work. noqueue means that the master cannot send a bast  
> to the
> holder.

Oh, that's bad.

> However, our notification scheme relies on the holder getting a  
> bast.
>
Yes.

> Maybe you should ignore the timer bit for the time being. That's a  
> separate piece
> anycase. Implement the other pieces. We'll get to the cancel convert later.
cancel convert for what? only the freeze lock or a command interface for
all cluster lock?
I don't know if it's needed for a commond cluster lock. But anyway,
seems the freeze/thaw relies on a cancelable(or a timeout version of) cluster
lock. Otherwise, the lock will wait for thaw for ever. If there is a umount at
the time, ocfs2 cleaning up hangs(at flushing work queue). Yes maybe we have a
way to postpone the umount if we are aquiring the PR lock, but that also
means if the cluster is frozen, umount has to wait until cluster thawed(this
is bad).

So, if we have plan to implement cancelable cluster lock(or a timeout version of
cluster lock). I think we'd better do that before supporting freeze/thaw.

regards,
wengang.
