﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;
using com.ashaw.pricing;

[ServiceContract(Namespace = "")]
[AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
public class QuoteService
{
	// To use HTTP GET, add [WebGet] attribute. (Default ResponseFormat is WebMessageFormat.Json)
	// To create an operation that returns XML,
	//     add [WebGet(ResponseFormat=WebMessageFormat.Xml)],
	//     and include the following line in the operation body:
	//         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml";
	[OperationContract]
    [WebInvoke(Method = "POST")]
	public void RenewQuote(int QuoteId)
	{
        throw new NotImplementedException();
	}

	// Add more operations here and mark them with [OperationContract]
    [OperationContract]
    [WebInvoke(Method="POST")]
    public void CloseQuote(int QuoteId)
    {
        Quote.Close(QuoteId);
        return;
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void AssignQuote(int QuoteId, int newUserId)
    {
        Quote q = new Quote(QuoteId);
        q.OwnerId = newUserId;
        q.Save();
        return;
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void MakeQuoteTemplate(int QuoteId)
    {
        Quote q = new Quote(QuoteId);
        q.Status = "template";
        q.Save();
        return;
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void CreateProductLine(string Name, string Description, string ProductManager)
    {
        ProductLine p = new ProductLine();
        p.Name = Name;
        p.Description = Description;
        p.ProductManager = ProductManager;
        p.Create();
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void SaveProductLine(int Id, string Name, string Description, string ProductManager)
    {
        ProductLine p = new ProductLine(Id);
        p.Name = Name;
        p.Description = Description;
        p.ProductManager = ProductManager;
        p.Save();
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void CreatePricelist(string Name, int OwnerId, string ProductLines, string Currency, string IsPublic)
    {
        Pricelist p = new Pricelist();
        p.Name = Name;
        p.IsDefault = false;
        p.IsPrivate = (IsPublic != "on" ); 
        p.OwnerId = OwnerId; 
        p.Currency = Currency;
        p.Date = DateTime.Now;
        Pricelist new_p = p.Create();
        foreach ( string productLineId in ProductLines.Split(',')){
            if (!String.IsNullOrEmpty(productLineId))
                p.AttachProductLine(Convert.ToInt32(productLineId));
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void SavePricelist(int Id, string Name, int OwnerId, string ProductLines, string Currency, string IsPublic)
    {
        Pricelist p = new Pricelist(Id);
        p.Name = Name;
        p.IsDefault = false;
        p.IsPrivate = (IsPublic != "on");
        p.OwnerId = OwnerId;
        p.Currency = Currency;
        p.Date = DateTime.Now;
        p.Save();
        p.ClearProductLines();
        foreach (string productLineId in ProductLines.Split(','))
        {
            if (!String.IsNullOrEmpty(productLineId))
                p.AttachProductLine(Convert.ToInt32(productLineId));
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void DeletePricelist(int Id)
    {
        Pricelist.Delete(Id);
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void DeleteProduct(int Id)
    {
        Product.Delete(Id);
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void DeleteProductLine(int Id)
    {
        ProductLine.Delete(Id);
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void CreateProduct( string Title, string Group, string SubGroup, string Partcode, string Manufacturer, string Description, string InternalNotes, string Availability, string ProductLines ) {
        Product p = new Product();
        p.Title = Title;
        p.Group = Group;
        p.SubGroup = SubGroup;
        p.Partcode = Partcode;
        p.Manufacturer = Manufacturer;
        p.Description = Description;
        p.InternalNotes = InternalNotes;
        p.Availability = Availability;
        Product newProduct = p.Create();
        foreach (string productLineId in ProductLines.Split(','))
        {
            if (!String.IsNullOrEmpty(productLineId))
             newProduct.AttachProductLine(Convert.ToInt32(productLineId));
        }
    }
    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void SaveProduct(int Id, string Title, string Group, string SubGroup, string Partcode, string Manufacturer, string Description, string InternalNotes, string Availability, string ProductLines)
    {
        Product p = new Product(Id);
        p.Title = Title;
        p.Group = Group;
        p.SubGroup = SubGroup;
        p.Partcode = Partcode;
        p.Manufacturer = Manufacturer;
        p.Description = Description;
        p.InternalNotes = InternalNotes;
        p.Availability = Availability;
        p.Save();
        p.ClearProductLines();
        foreach (string productLineId in ProductLines.Split(','))
        {
            if (!String.IsNullOrEmpty(productLineId))
                p.AttachProductLine(Convert.ToInt32(productLineId));
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void CreatePackage(string Title, string Configurable, string InheritPrice, string InheritCost, string Manufacturer, string Partcode, string DescriptionTemplate, string Availability,string ProductLines)
    {
        Package p = new Package();
        p.Title = Title;
        p.Configurable = (Configurable=="on");
        p.InheritPrice = (InheritPrice=="on");
        p.InheritCost = (InheritCost=="on");
        p.Manufacturer = Manufacturer;
        p.Partcode = Partcode;
        p.DescriptionTemplate = DescriptionTemplate;
        p.Availability = Availability;
        Package newProduct = p.Create();
        foreach (string productLineId in ProductLines.Split(','))
        {
            if (!String.IsNullOrEmpty(productLineId))
                newProduct.AttachProductLine(Convert.ToInt32(productLineId));
        }
    }
    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void SavePackage(int Id, string Title, string Configurable, string InheritPrice, string InheritCost, string Manufacturer, string Partcode, string DescriptionTemplate, string Availability, string ProductLines)
    {
        Package p = new Package(Id);
        p.Title = Title;
        p.Configurable = (Configurable=="on");
        p.InheritPrice = (InheritPrice=="on");
        p.InheritCost = (InheritCost=="on");   
        p.Manufacturer = Manufacturer;
        p.Partcode = Partcode;
        p.DescriptionTemplate = DescriptionTemplate;
        p.Availability = Availability;
        p.Save();
        p.ClearProductLines();
        foreach (string productLineId in ProductLines.Split(','))
        {
            if (!String.IsNullOrEmpty(productLineId))
                p.AttachProductLine(Convert.ToInt32(productLineId));
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST")]
    public void SavePackageComponents(int OwningPackageId, PackageComponent[] Components)
    {
        Package package = new Package(OwningPackageId);
        package.ClearPackageComponents();
        foreach (PackageComponent c in Components)
        {
            c.PackageId = OwningPackageId;
            PackageComponent newComponent = c.Create();
            // Attach the products
            foreach (string productId in c.ProductsString.Split(','))
                if (!String.IsNullOrEmpty(productId))
                    newComponent.AttachProduct(Convert.ToInt32(productId));
        }
    }
}
