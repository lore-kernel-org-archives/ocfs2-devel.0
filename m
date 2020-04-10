From: Gang He <GHe@suse.com>
Date: Fri, 10 Apr 2020 09:28:38 +0000
Subject: [Ocfs2-devel] mount existent ocfs2 volume in the local mode
 without the extra DLM, pacemaker/corosync layers
In-Reply-To: <cb66ec3a-b4be-f3e7-6a60-b57f38f33d2b@linux.alibaba.com>
References: <CH2PR18MB32064CAD825244DA21458730CFDE0@CH2PR18MB3206.namprd18.prod.outlook.com>,
	<cb66ec3a-b4be-f3e7-6a60-b57f38f33d2b@linux.alibaba.com>
Message-ID: <CH2PR18MB320631D4BCDE1DD01EE6D44FCFDE0@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Changwei,

See my comments inline.

________________________________________
From: Changwei Ge <chge@linux.alibaba.com>
Sent: Friday, April 10, 2020 5:08 PM
To: Gang He; ocfs2-devel at oss.oracle.com; ocfs2-users at oss.oracle.com
Subject: Re: [Ocfs2-devel] mount existent ocfs2 volume in the local mode without the extra DLM, pacemaker/corosync layers

Hello Gang,

On 4/10/20 4:36 PM, Gang He wrote:
> Hello Guys,
>
> Usually, we create a ocfs2 cluster on the top DLM(pacemaker/corosync) with a shared volume.
> but the customers complained they could not mount existent ocfs2 volume in the local mode without DLM/cluster envirnment in backup/restore scenario.
> in this case, the customers want to mount this ocfs2 volume from one node without cluster aware way, sometimes the customers have stoped(uninstalled) the whole cluster before the backup/restore, they just want to access the data from the ocfs2 volume.
> Then, I'd like to add a mount option, e.g. "nocluster" (I feel using "local" option is a little confused for the users, since we have a local mount volume concept).
> If the users use "nocluster" option to mount a ocfs2 volume, the whole mount will not depend on the DLM/cluster related services. they
> will mount the existent ocfs2 volume directly (like local mount) for avoiding setup the cluster stacks.
> The code change is small with my preliminary investigation, the main affected places are mount.ocfs2/mounted.ocfs2 tools and mount process in the ocfs2 kernel modules.

Some quick questions:

1.Will the 'nocluster' ocfs2 volume be read-only?
The user can read or write this mount (like local mount), but the user needs to make sure only one node can mount 
the volume like this way.

2.How to achieve filesystem consistency if the whole cluster or some
members of it crashed before this 'nocluster' mount.
The mount process will do the recovery for each node's journal, but the mount process will not do DLM related things. 

3.Is there any mechanism guard protecting no other node do mount after
this 'nocluster' mount.
Not, we can give a warning during the mount period.
If the customer need to understand this risk. 

4.Why do we have potential work for mounted.ocfs2?
Maybe we need to add some code, let mounted.ocfs2 aware this mount option.
In short, I am not 100% sure if there is something to do.

5.I feel debugfs.ocfs2 can dump specified file or entire volume, is that
satisfied for you?
For the developer, we can do like that way.
But for the customer, it is too hard.
and that, the customer wants to access lots of files for one time.

Thanks
Gang

Thanks,
Changwei


>
> Any comments/suggestions?
>
>
> Thanks a lot
> Gang
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
