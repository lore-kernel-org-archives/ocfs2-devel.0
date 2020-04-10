From: Gang He <GHe@suse.com>
Date: Fri, 10 Apr 2020 10:16:33 +0000
Subject: [Ocfs2-devel] mount existent ocfs2 volume in the local mode
 without the extra DLM, pacemaker/corosync layers
In-Reply-To: <140dda1e-35bd-67fe-a3d4-df3222550984@gmail.com>
References: <CH2PR18MB32064CAD825244DA21458730CFDE0@CH2PR18MB3206.namprd18.prod.outlook.com>,
	<140dda1e-35bd-67fe-a3d4-df3222550984@gmail.com>
Message-ID: <CH2PR18MB3206F9F31924F1AF395EB1B3CFDE0@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Jeseph,

________________________________________
From: Joseph Qi <jiangqi903@gmail.com>
Sent: Friday, April 10, 2020 6:00 PM
To: Gang He; ocfs2-devel at oss.oracle.com; ocfs2-users at oss.oracle.com
Subject: Re: [Ocfs2-devel] mount existent ocfs2 volume in the local mode without the extra DLM, pacemaker/corosync layers

Just be curious about this user scenario.
What is "without DLM/cluster environment"?

The user can mount the existent ocfs2 cluster volume directly, does not depend on if DLM/cluster services are available.
When this option is added, the mount process  will not do dlm related things, like local mount.
This way will help the user access the files in the volume quickly for avoiding setup/online the cluster environment.

Thanks
Gang
 
Thanks,
Joseph

On 2020/4/10 16:36, Gang He wrote:
> Hello Guys,
>
> Usually, we create a ocfs2 cluster on the top DLM(pacemaker/corosync) with a shared volume.
> but the customers complained they could not mount existent ocfs2 volume in the local mode without DLM/cluster envirnment in backup/restore scenario.
> in this case, the customers want to mount this ocfs2 volume from one node without cluster aware way, sometimes the customers have stoped(uninstalled) the whole cluster before the backup/restore, they just want to access the data from the ocfs2 volume.
> Then, I'd like to add a mount option, e.g. "nocluster" (I feel using "local" option is a little confused for the users, since we have a local mount volume concept).
> If the users use "nocluster" option to mount a ocfs2 volume, the whole mount will not depend on the DLM/cluster related services. they
> will mount the existent ocfs2 volume directly (like local mount) for avoiding setup the cluster stacks.
> The code change is small with my preliminary investigation, the main affected places are mount.ocfs2/mounted.ocfs2 tools and mount process in the ocfs2 kernel modules.
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
