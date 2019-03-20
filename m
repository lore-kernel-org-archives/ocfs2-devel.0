From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 20 Mar 2019 10:44:01 +0000
Subject: [Ocfs2-devel] [Ocfs2-users] o2locktop introduction
Message-ID: <71604351584F6A4EBAE558C676F37CA4013BFE7DA0@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Good News.

Thanks.


> -----????-----
> ???: ocfs2-users-bounces at oss.oracle.com
> [mailto:ocfs2-users-bounces at oss.oracle.com] ?? Gang He
> ????: 2019?3?20? 18:07
> ???: ocfs2-devel at oss.oracle.com; ocfs2-tools-devel at oss.oracle.com;
> ocfs2-users at oss.oracle.com
> ??: [Ocfs2-users] o2locktop introduction
> 
> Hello Guys,
> 
> We wrote a tool with Python, which is used to display DLM lock usages in a OCFS2
> cluster.
> o2locktop is a top-like OCFS2 DLM lock monitor, it displays DLM lock usages via
> querying OCFS2 file system statistics from the specified nodes.
> Therefore, OCFS2 kernel modules must enable OCFS2_FS_STATS configuration
> option when compiling.
> If you want to know if the current OCFS2 kernel modules enable OCFS2_FS_STATS
> setting, you can refer to /boot/config-`uname -r` file.
> You can utilize o2locktop to detect the hot files/directories, whose DLM locks are
> frequently referenced among the cluster.
> You can get the maximal wait time per DLM lock, this helps you identify which hot
> files/directories should be decoupled for improving file access performance.
> For more details, please visit the link
> https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_ganghe_o2lockt
> op&d=DwIFAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=wXmkJN
> AUtutY0U9inuQWCbzSSRji5zLpyR0a_Mek4jM&m=93wGE0zLoHuCKph4-kgDwzuZm9
> oc1J4Mhz9PxVbVxZc&s=lVluTYcXetvTd2GFdOJLcqDtQcWFhVrDY5I6MI1r_Ow&e=
> This tool is expected to be used for SUSE customer, if you are interested, welcome
> to use, to contribute, suggestions, etc.
> 
> Thanks a lot.
> Gang
> 
> 
> 
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-users
