using System;

namespace OAuth2Demo.Controllers
{
    /// <summary>
    /// Holder for file data
    /// </summary>
    public class DataFile
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Sex { get; set; }
        public string FriendlyDesc1 { get; set; }
        public string FriendlyDesc2 { get; set; }
        public string Population { get; set; }
        public string FileCategory { get; set; }
        public string Ext { get; set; }
        public string FileType { get; set; }
        public string FileSubType { get; set; }
    }
}