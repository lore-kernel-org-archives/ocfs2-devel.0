From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 28 Jul 2010 22:45:33 +0800
Subject: [Ocfs2-devel] Global heartbeat - drop#1
In-Reply-To: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100728144533.GA3128@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

The global heartbeat also introduce a difference comparing with local heart.
With the ghb, what if the non-heartbeat ocfs2 volume(s) fail(s)? Say some lower
layer(raid/disk-driver) become unhappy to work anymore. In case, no failover
since no self-fence I think. So it could cause the domain in question
unavailable(finally), isn't it? With the original lhb scheme, no such problem.
Is there a solution?

regards,
wengang.

On 10-07-23 16:55, Sunil Mushran wrote:
> 
> This is the first drop of the global heartbeat patches for ocfs2/kernel.
> 
> The first few patches add support for heartbeat mode in sysfs, the new
> incompat clusterinfo flag and the new mount option heartbeat=global.
> 
> 0001-ocfs2-cluster-Add-heartbeat-mode-configfs-parameter.patch
> 0002-ocfs2-Add-an-incompat-feature-flag-OCFS2_FEATURE_INC.patch
> 0003-ocfs2-Add-support-for-heartbeat-global-mount-option.patch
> 0004-ocfs2-dlm-Expose-dlm_protocol-in-dlm_state.patch
> 
> The next few patches enhance the join domain protocol to get the list
> of configured nodes and heartbeating regions to ensure that all nodes
> in the cluster have the same view of the cluster.
> 
> 0005-ocfs2-cluster-Get-all-heartbeat-regions.patch
> 0006-ocfs2-dlm-Add-message-DLM_QUERY_HBREGION.patch
> 0007-ocfs2-Print-message-if-user-mounts-without-starting-.patch
> 0008-ocfs2-dlm-Add-message-DLM_QUERY_NODEINFO.patch
> 
> The one known missing bit concerns quorum calculation. I am still
> working on it.
> 
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/NewGlobalHeartbeat
> 
> Thanks
> Sunil
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
