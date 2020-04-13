From: Gang He <GHe@suse.com>
Date: Mon, 13 Apr 2020 10:42:14 +0000
Subject: [Ocfs2-devel] [Ocfs2-users] mount existent ocfs2 volume in the
 local mode without the extra DLM, pacemaker/corosync layers
In-Reply-To: <8692221f-c0e3-c741-00d2-8a9cefc759ea@oracle.com>
References: <CH2PR18MB32064CAD825244DA21458730CFDE0@CH2PR18MB3206.namprd18.prod.outlook.com>
	<8692221f-c0e3-c741-00d2-8a9cefc759ea@oracle.com>
Message-ID: <CH2PR18MB3206C2C7A99DEB17969501C3CFDD0@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Herbert,

As you know, ocfs2 has two cluster stacks,
One is o2cb, the other one is pcmk.
For o2cb stack, ocfs2 will use heartbeat argument.
When the volume is detected as a local-mount volume, mount.ocfs2 will pass "heartbeat=none" argument to mount system call.
For pcmk stack, ocfs2 does not use heartbeat mount option, that means heartbeat option is always none.


Thanks
Gang 

> -----Original Message-----
> From: ocfs2-users-bounces at oss.oracle.com
> [mailto:ocfs2-users-bounces at oss.oracle.com] On Behalf Of
> herbert.van.den.bergh at oracle.com
> Sent: 2020?4?11? 1:10
> To: Gang He <GHe@suse.com>; ocfs2-devel at oss.oracle.com;
> ocfs2-users at oss.oracle.com
> Subject: Re: [Ocfs2-users] [Ocfs2-devel] mount existent ocfs2 volume in the
> local mode without the extra DLM, pacemaker/corosync layers
> 
> Hello Gang,
> 
> The option to mount without a clusterstack is: heartbeat=none
> 
> Give that a try and let us know if that doesn't work.
> 
> Thanks,
> Herbert.
> 
> On 4/10/20 1:36 AM, Gang He wrote:
> > Hello Guys,
> >
> > Usually, we create a ocfs2 cluster on the top DLM(pacemaker/corosync) with
> a shared volume.
> > but the customers complained they could not mount existent ocfs2 volume
> in the local mode without DLM/cluster envirnment in backup/restore scenario.
> > in this case, the customers want to mount this ocfs2 volume from one node
> without cluster aware way, sometimes the customers have stoped(uninstalled)
> the whole cluster before the backup/restore, they just want to access the data
> from the ocfs2 volume.
> > Then, I'd like to add a mount option, e.g. "nocluster" (I feel using "local"
> option is a little confused for the users, since we have a local mount volume
> concept).
> > If the users use "nocluster" option to mount a ocfs2 volume, the whole
> > mount will not depend on the DLM/cluster related services. they will mount
> the existent ocfs2 volume directly (like local mount) for avoiding setup the
> cluster stacks.
> > The code change is small with my preliminary investigation, the main
> affected places are mount.ocfs2/mounted.ocfs2 tools and mount process in
> the ocfs2 kernel modules.
> >
> > Any comments/suggestions?
> >
> >
> > Thanks a lot
> > Gang
> >
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-users
