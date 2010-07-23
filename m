From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 23 Jul 2010 16:55:14 -0700
Subject: [Ocfs2-devel] Global heartbeat - drop#1
Message-ID: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


This is the first drop of the global heartbeat patches for ocfs2/kernel.

The first few patches add support for heartbeat mode in sysfs, the new
incompat clusterinfo flag and the new mount option heartbeat=global.

0001-ocfs2-cluster-Add-heartbeat-mode-configfs-parameter.patch
0002-ocfs2-Add-an-incompat-feature-flag-OCFS2_FEATURE_INC.patch
0003-ocfs2-Add-support-for-heartbeat-global-mount-option.patch
0004-ocfs2-dlm-Expose-dlm_protocol-in-dlm_state.patch

The next few patches enhance the join domain protocol to get the list
of configured nodes and heartbeating regions to ensure that all nodes
in the cluster have the same view of the cluster.

0005-ocfs2-cluster-Get-all-heartbeat-regions.patch
0006-ocfs2-dlm-Add-message-DLM_QUERY_HBREGION.patch
0007-ocfs2-Print-message-if-user-mounts-without-starting-.patch
0008-ocfs2-dlm-Add-message-DLM_QUERY_NODEINFO.patch

The one known missing bit concerns quorum calculation. I am still
working on it.

http://oss.oracle.com/osswiki/OCFS2/DesignDocs/NewGlobalHeartbeat

Thanks
Sunil
